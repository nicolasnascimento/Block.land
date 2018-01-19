//
//  Coordinator.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 16/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import GameplayKit

final class Coordinator: NSObject {
    
    // MARK: - Public
    
    // The scene in which AR content is displayed
    weak var view: ARSCNView?
    
    // The entity object manager
    var manager: EntityManager

    /// The canvasNode in which all nodes are added
    private var canvasNode: SCNNode!
    
    // A flag to indicate if plane was already detected
    private var planeAnchor: ARPlaneAnchor?
    private var planeIterations = 1
    private var midPoint: CGPoint = .zero
    
    // Focus
    private var currentFocusedComponent: FocusableComponent? = nil
    private var currentFocusedPosition: SCNVector3 = SCNVector3()
    private var currentFocusedRotation: SCNVector4 = SCNVector4()
    
    // MARK: - Initialization
    init(view: ARSCNView) {

        // Initialize manager
        self.manager = EntityManager()
        
        // Perform superclass initialization
        super.init()
        
        // Assign view weak reference
        self.view = view
        
        
        // Load base world from file
        guard let scene = SCNScene(named: Environment.Files.baseWorldScene) else { fatalError("Couldn't load base world scene from file: \(Environment.Files.baseWorldScene)") }
        self.view?.scene = scene
        
        // Add canvas node
        self.canvasNode = self.view?.scene.rootNode.childNode(withName: "canvasNode", recursively: true)!
        self.view?.scene.rootNode.addChildNode(self.canvasNode)
        
        // Debug
        if( Environment.debugMode ) {
            
            // FPS, Node Counte, etc
            self.view?.showsStatistics = true
            
            // Physics
            self.view?.debugOptions = []
        }
    }
    
    // MARK: - Public Methods
    func begin() {
        
        // Create configuration for world tracking
        let configuration = ARWorldTrackingConfiguration()
        
        // Set Plane Detection
        configuration.planeDetection = .horizontal
        
        // Run session
        self.view?.session.run(configuration)
        
        // Set midPoint
        self.midPoint = CGPoint(x: self.view!.bounds.size.width*0.5, y: self.view!.bounds.size.height*0.5)
        
        // Make sure delegate callbacks will be provided
        self.view?.delegate = self
        self.manager.delegate = self
        (self.view?.parentViewController as? MainViewController)?.overlay.delegate = self
    }
    
    // MARK: - Private
    private func add(_ node: SCNNode) {
        self.canvasNode.addChildNode(node)
    }
}

extension Coordinator: ARSCNViewDelegate {
    
    private func handlePlaneAnchorDetection(for newPlaneAnchor: ARPlaneAnchor) {
        if planeIterations > 0 {
            
            // Iterate on plane detection
            planeIterations -= 1
            
            // Stop tracking
            if( planeIterations == 0 ) {
                let configuration = ARWorldTrackingConfiguration()
                self.view?.session.run(configuration)
            }
            
            if let currentPlaneAnchor = self.planeAnchor {
                if currentPlaneAnchor != newPlaneAnchor {
                    return
                }
            } else {
                self.planeAnchor = newPlaneAnchor
                
                print("Detected Plane")
                print("Setting Transform \(self.canvasNode.position)")
                self.canvasNode.animatedSet(simdTransform: newPlaneAnchor.transform)
                self.canvasNode.rotation = SCNVector4()
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Check if plane was detected
        guard let newPlaneAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Perform Apropriate handling of plane detected
        self.handlePlaneAnchorDetection(for: newPlaneAnchor)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        // Hit test and only used node which is the top most position
        if let firstResult = renderer.hitTest(self.midPoint, options: [:]).first {
            
            // This means the only thing in front of the object is a plane
            if( firstResult.node.geometry is SCNFloor ) {
                self.currentFocusedPosition = firstResult.worldCoordinates
//                self.currentFocusedRotation = firstResult.node.rotation
                
            } else {
                let focusComponent = firstResult.node.entity?.component(ofType: FocusableComponent.self)
                
                if( focusComponent != self.currentFocusedComponent ) {
                    
                    // Remove focus from old element
                    self.currentFocusedComponent?.state = .notFocused
                    
                    // Add focus to new element
                    focusComponent?.state = .focused
                    
                    // Set reference
                    self.currentFocusedComponent = focusComponent
                }
            }
        }
    }
    
}

extension Coordinator: EntityManagerDelegate {
    func entityManager(_ entityManager: EntityManager, didAdd entity: GKEntity) {
        
        if let blockComponent = entity.component(ofType: BlockComponent.self) {
            print("adding block node")
            
            let cubeSide = fabs(blockComponent.blockNode.boundingBox.max.x - blockComponent.blockNode.boundingBox.min.x)
            blockComponent.blockNode.position.y += cubeSide
            
            self.add(blockComponent.blockNode)
        }
    }
    
    func entityManager(_ entityManager: EntityManager, didRemove entity: GKEntity) {
        print(#function)
        print("Should remove visual representation here")
    }
    
    func entityManager(_ entityManager: EntityManager, didFailToRemove entity: GKEntity) {
        print(#function)
        print("Should display warning or attempt correction")
    }
}

extension Coordinator: OverlayDelegate {
    func overlay(_ overlay: Overlay, didPressAdd button: UIButton) {
        
        // For now, simply add a regular block
        print(self.currentFocusedPosition)
        
        // Add Block
        self.manager.add(entity: Block(type: .random, at: (position: self.currentFocusedPosition, rotation: self.currentFocusedRotation)))
        
    }
    
}
