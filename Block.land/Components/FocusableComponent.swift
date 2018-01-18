//
//  FocusableComponent.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 18/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import GameplayKit
import SceneKit

final class FocusableComponent: GKComponent {
    
    enum State {
        case focused
        case notFocused
    }
    
    var animationDuration = 1.0
    var state: State = .notFocused {
        willSet {
            if( newValue != self.state ) {
                switch newValue {
                case .focused:
                    let scale = 1.2
                    
                    let height = (self.effectNode.boundingBox.max.y - self.effectNode.boundingBox.min.y)*Float(scale - 1.0)
                    self.effectNode.position.y += (self.effectNode.boundingBox.max.y - self.effectNode.boundingBox.min.y)*Float(scale - 1.0)
                    print(height)
                    
                    self.effectNode.physicsBody?.resetTransform()
                    
                    self.effectNode.scale = SCNVector3(scale, scale, scale)
                    
                case .notFocused:
                    
                    self.effectNode.scale = SCNVector3(1.0, 1.0, 1.0)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private let scaleActionKey = "scaleActionKey"
    private var effectNode: SCNNode
    
    
    init(effectNode: SCNNode) {
        self.effectNode = effectNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
