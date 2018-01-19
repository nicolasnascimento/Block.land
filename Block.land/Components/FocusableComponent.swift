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

                    // Blink Action
                    let angularSpeed = CGFloat.pi
                    let fadeOut = SCNAction.fadeOpacity(to: 0.5, duration: self.animationDuration*0.5)
                    let fadeIn = SCNAction.fadeOpacity(to: 1.0, duration: self.animationDuration*0.5)
                    let fade = SCNAction.repeatForever(SCNAction.sequence([fadeOut, fadeIn]))
                    
                    self.effectNode.runAction(fade, forKey: self.fadeActionKey)

                    
                case .notFocused:
                    
                    // Restore Default values
                    let fadeIn = SCNAction.fadeIn(duration: self.animationDuration)
                    self.effectNode.runAction(fadeIn, forKey: self.fadeActionKey)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private let fadeActionKey = "rotationActionKey"
    private var effectNode: SCNNode
    
    
    init(effectNode: SCNNode) {
        self.effectNode = effectNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
