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
    weak var view: ARSCNView? { return self.overlay.view.superview as? ARSCNView }
    
    // The entity object manager
    var manager: EntityManager
    
    // The Overlay manager
    private var overlay: Overlay

    /// The canvasNode in which all nodes are added
    private var canvasNode: SCNNode!
    private let canvasNodeName: String = "canvasNode"
    
    // A flag to indicate if plane was already detected
    private var planeAnchor: ARPlaneAnchor?
    private var planeIterations = 1
    private var midPoint: CGPoint = .zero
    
    // Focus
    private var currentFocusedBlock: Block?
    private var currentFocusedPosition: SCNVector3 = SCNVector3()
    private var currentFocusedRotation: SCNVector4 = SCNVector4()
    
    // MARK: - Initialization
    init(overlay: Overlay) {

        // Initialize Overaly
        self.overlay = overlay        
        
        // Initialize manager
        self.manager = EntityManager()
        
        // Perform superclass initialization
        super.init()
        
        // Load base world from file
        guard let scene = SCNScene(named: Environment.Files.baseWorldScene) else {
            let failMessage = "Couldn't load base world scene from file: \(Environment.Files.baseWorldScene)"
            fatalError(failMessage)
        }
        self.view?.scene = scene
        
        // Add canvas node
        self.canvasNode = self.view?.scene.rootNode.childNode(withName: self.canvasNodeName, recursively: true)!
        self.view?.scene.rootNode.addChildNode(self.canvasNode)
        
        // Debug
        if Environment.debugMode {
            
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
        self.overlay.delegate = self
        
        // Update Overlay
        self.overlay.state = .normal
    }
    
    // MARK: - Private
    private func add(_ node: SCNNode) {
        self.canvasNode.addChildNode(node)
    }
    
    // Stores/Update Plane if possible
    private func handlePlaneAnchorDetection(for newPlaneAnchor: ARPlaneAnchor) {
        if planeIterations > 0 {
            
            // Iterate on plane detection
            planeIterations -= 1
            
            // Stop tracking
            if planeIterations == 0 {
                DispatchQueue.main.async {
                    let configuration = ARWorldTrackingConfiguration()
                    
                    self.view?.session.run(configuration)
                }
            }
            
            if let currentPlaneAnchor = self.planeAnchor {
                if currentPlaneAnchor != newPlaneAnchor {
                    return
                }
            } else {
                self.planeAnchor = newPlaneAnchor
                
                DispatchQueue.main.async {
                    self.overlay.hasPlane = true
                }
                
                print("Detected Plane")
                print("Setting Transform \(self.canvasNode.position)")
                self.canvasNode.animatedSet(simdTransform: newPlaneAnchor.transform)
                self.canvasNode.rotation = SCNVector4()
            }
        }
    }
}

extension Coordinator: ARSCNViewDelegate {
    
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
            if firstResult.node.geometry is SCNFloor {
                self.currentFocusedPosition = firstResult.worldCoordinates
                
            }
            
            let block = firstResult.node.entity as? Block

            if block != self.currentFocusedBlock {
                
                // Remove focus from old element
                self.currentFocusedBlock?.component(ofType: FocusableComponent.self)?.state = .notFocused

                // Add focus to new element
                block?.component(ofType: FocusableComponent.self)?.state = .focused
                
                // Set reference
                self.currentFocusedBlock = block
                
                // Update Overlay
                var newState = Overlay.State.unknown
                if self.currentFocusedBlock != nil {
                    newState = .editingBlock
                } else {
                    newState = .normal
                }
                if newState != self.overlay.state {
                    DispatchQueue.main.async {
                        self.overlay.state = newState
                        UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4) {
                            self.view?.layoutIfNeeded()
                        }.startAnimation()
                    }
                }
            }
        } else {
            // Remove focus from old element
            self.currentFocusedBlock?.component(ofType: FocusableComponent.self)?.state = .notFocused
            
            // Remove reference
            self.currentFocusedBlock = nil
        }
    }
    
}

extension Coordinator: EntityManagerDelegate {
    func entityManager(_ entityManager: EntityManager, didAdd entity: GKEntity) {
        
        if let blockComponent = entity.component(ofType: BlockComponent.self) {
            print("adding block node")
            
            let cubeSide = abs(blockComponent.blockNode.boundingBox.max.x - blockComponent.blockNode.boundingBox.min.x)
            blockComponent.blockNode.position.y += cubeSide
            
            self.add(blockComponent.blockNode)
        }
    }
    
    func entityManager(_ entityManager: EntityManager, didRemove entity: GKEntity) {
        // Remove Node from Scene
        entity.component(ofType: BlockComponent.self)?.blockNode.removeFromParentNode()
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
        self.manager.add(entity:
            Block(type: .random,
                  at: (position: self.currentFocusedPosition,
                       rotation: self.currentFocusedRotation))
        )
        
    }
    
    func overlay(_ overlay: Overlay, didSelect option: BlockComponent.BlockMaterialType) {
        if let focusedBlock = self.currentFocusedBlock {
            
            focusedBlock.type = option
            
        }
        
    }
}
