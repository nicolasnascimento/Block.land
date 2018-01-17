//
//  BlockComponent.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 16/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import GameplayKit

final class BlockComponent: GKComponent {
    
    // The block node this component manages
    var blockNode: SCNNode
    
    /// The type of material to be used in the block
    enum BlockMaterialType: String {
        case brown = "brown"
        case lightOrange = "lightOrange"
        case darkOrange = "darkOrange"
        case darkBrown = "darkBrown"
        
        static var random: BlockMaterialType {
            switch arc4random_uniform(4) {
            case 0: return .lightOrange
            case 1: return .darkOrange
            case 2: return .darkBrown
            default: return .brown
            }
        }
    }
    
    // MARK: - Initialization
    init(dimensions: CGSize3, type: BlockMaterialType = BlockMaterialType.random, chamferRadius: CGFloat = 0.01) {
        // Create Geometry
        let geometry = SCNBox(width: dimensions.width, height: dimensions.height, length: dimensions.length, chamferRadius: chamferRadius)
        geometry.firstMaterial?.diffuse.contents = UIImage(named: type.rawValue)        
        geometry.firstMaterial?.normal.contents = UIImage(named: "wood-normal")
        geometry.firstMaterial?.lightingModel = .physicallyBased
        
        
        // Create node
        self.blockNode = SCNNode(geometry: geometry)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}