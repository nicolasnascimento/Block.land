//
//  Block.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 16/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import GameplayKit

final class Block: GKEntity {
    
    // The default size of the block
    private let defaultDimension = CGSize3(width: 0.1, height: 0.1, length: 0.1)
    
    // The type associated with the block
    var type: BlockComponent.BlockMaterialType {
        get { return self.component(ofType: BlockComponent.self)!.type }
        set { self.component(ofType: BlockComponent.self)!.type = newValue }
    }
    
    // MARK: - Initialization
    init(type: BlockComponent.BlockMaterialType, at spatialCoordinate: (position: SCNVector3, rotation: SCNVector4)? = nil) {
        super.init()
        
        // Create the 3D block representation
        let blockComponent = BlockComponent(dimensions: defaultDimension, type: type)
        self.addComponent(blockComponent)
        
        // Allow back reference
        blockComponent.blockNode.entity = self
        
        // Add physics to block
        let physicsComponent = PhysicsComponent(node: blockComponent.blockNode, type: .dynamic)
        blockComponent.blockNode.physicsBody = physicsComponent.body
        self.addComponent(physicsComponent)
        
        let focusComponent = FocusableComponent(effectNode: blockComponent.blockNode)
        self.addComponent(focusComponent)
        
        // If transform matrix was specified, use it
        if let coordinate = spatialCoordinate {
            blockComponent.blockNode.position = coordinate.position
            blockComponent.blockNode.rotation = coordinate.rotation
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
