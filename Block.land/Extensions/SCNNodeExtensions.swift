//
//  SCNNodeExtensions.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 17/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import SceneKit

extension SCNNode {
    
    func animatedSet(simdTransform: simd_float4x4, duration: CFTimeInterval = 1.0, completion: (() -> Void)? = nil) {
        
        // Begin Transaction
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        
        // We need to update the physics for the node after animation, so set completion block
        SCNTransaction.completionBlock = { [weak self] in
            // Update Physics Transform to match new transform
            self?.childNodes.forEach { $0.physicsBody?.resetTransform() }
            
            // Done, So call completion handler
            completion?()
        }
        
        // Assign new value
        self.simdTransform = simdTransform
        
        // Perform Animation
        SCNTransaction.commit()
    }
    
}
