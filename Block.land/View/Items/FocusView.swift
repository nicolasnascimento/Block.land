//
//  FocusView.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 18/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

class FocusView: UIView {
    
    
    // MARK: - Public Properties
    enum Status {
        case idle
        case foundObject
    }
    
    // Status for Focus View
    var animationDuration = 0.1
    var maxScale: CGFloat = 1.2
    var status: Status = .idle {
        willSet {
            if newValue != self.status {
                switch newValue {
                case .foundObject:
                    let maxScale = self.maxScale
                    UIView.animate(withDuration: self.animationDuration) { [weak self] in
                        self?.transform = CGAffineTransform.identity.scaledBy(x: maxScale, y: maxScale)
                    }
                    UIView.setAnimationCurve(.easeOut)
                case .idle:
                    UIView.animate(withDuration: self.animationDuration) { [weak self] in
                        self?.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                    }
                }
            }
        }
    }
    
    // MARK: - Override
    
    override func draw(_ rect: CGRect) {
        
        // Corner radius
        self.layer.cornerRadius = rect.size.height/2
        
        // Border
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
}
