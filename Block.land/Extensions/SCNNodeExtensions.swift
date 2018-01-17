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
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.completionBlock = { [weak self] in
            
            for node in self?.childNodes ?? [] {
                node.physicsBody?.resetTransform()
            }
            
            completion?()
        }
        
        self.simdTransform = simdTransform
        
        SCNTransaction.commit()
        
    }
    
}
