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
    
    // MARK: - Initialization
    init(view: ARSCNView) {

        // Initialize manager
        self.manager = EntityManager()
        
        // Perform superclass initialization
        super.init()
        
        // Assign view weak reference
        self.view = view
        
        // Configuration
        self.view?.showsStatistics = true
        
        // Load base world from file
        guard let scene = SCNScene(named: Environment.Files.baseWorldScene) else { fatalError("Couldn't load base world scene from file: \(Environment.Files.baseWorldScene)") }
        self.view?.scene = scene
        
        // Add canvas node
        self.canvasNode = self.view?.scene.rootNode.childNode(withName: "canvasNode", recursively: true)!
        self.view?.scene.rootNode.addChildNode(self.canvasNode)
        
        // Make sure delegate callbacks will be provided
        self.view?.delegate = self
        self.manager.delegate = self
        (self.view?.parentViewController as? MainViewController)?.overlay.delegate = self
    }
    
    // MARK: - Public Methods
    func begin() {
        
        // Create configuration for world tracking
        let configuration = ARWorldTrackingConfiguration()
        
        // Set Plane Detection
        configuration.planeDetection = .horizontal
        
        // Run session
        self.view?.session.run(configuration)
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
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Check if plane was detected
        guard let newPlaneAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Perform Apropriate handling of plane detected
        self.handlePlaneAnchorDetection(for: newPlaneAnchor)
    }
    
}

extension Coordinator: EntityManagerDelegate {
    func entityManager(_ entityManager: EntityManager, didAdd entity: GKEntity) {
        
        if let blockComponent = entity.component(ofType: BlockComponent.self) {
            print("adding block node")
            blockComponent.blockNode.position.y += 1.0
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
        self.manager.add(entity: Block(type: .random))
        
    }
    
}
