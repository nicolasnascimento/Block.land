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
    
    // MARK: - Initialization
    init(type: BlockComponent.BlockMaterialType) {
        super.init()
        
        // Create the 3D block representation
        let blockComponent = BlockComponent(dimensions: defaultDimension, type: type)
        self.addComponent(blockComponent)
        
        // Add physics to block
        let physicsComponent = PhysicsComponent(node: blockComponent.blockNode, type: .dynamic)
        blockComponent.blockNode.physicsBody = physicsComponent.body
        self.addComponent(physicsComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
