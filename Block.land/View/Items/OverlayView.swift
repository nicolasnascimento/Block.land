//
//  OverlayView.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 22/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

// All items used in the overlay conform to this protocol, allowing for
protocol OverlayView {
    
    // Control Variavble for an Overlay View
    var controlConstraint: NSLayoutConstraint { get set }
    var controlConstantValue: CGFloat { get set }
    var controlOffsetDistance: CGFloat { get }
    var controlAnimationDuration: TimeInterval { get }
    
    /// Should return true if the view should appear in the associated state
    func shouldBeVisible(for state: Overlay.State) -> Bool
    
    // Should remove elements from screen, using the controlConstraint and its original value
    func hide()
    
    // Should add elements to screen, using the controlConstraint and its original value
    func show()
}

/// MARK: - Default Implementation
extension OverlayView where Self: UIView {
    
    var controlOffsetDistance: CGFloat {
        return self.frame.size.height*2.0
    }
    var controlAnimationDuration: TimeInterval {
        return 1.0
    }
    
    func hide() {
        // Simply Set Constraint
        self.controlConstraint.constant = self.controlConstantValue + self.controlOffsetDistance
    }
    
    func show() {
        // Simply Set Constraint
        self.controlConstraint.constant = self.controlConstantValue
    }
}
