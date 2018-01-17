//
//  PhysicsComponent.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 16/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import GameplayKit

final class PhysicsComponent: GKComponent {
    
    var body: SCNPhysicsBody
    
    init(node: SCNNode, type: SCNPhysicsBodyType = .dynamic) {
        self.body = SCNPhysicsBody(type: type, shape: SCNPhysicsShape(geometry: node.geometry!, options: [:]))
        self.body.isAffectedByGravity = true
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
