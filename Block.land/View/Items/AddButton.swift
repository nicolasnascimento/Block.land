//
//  Button.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 22/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

/// The class used for buttons in the overlay
final class AddButton: UIButton {
    
    // Set default values. This will be overriden later
    var controlConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var controlConstantValue: CGFloat = 0
}

// MARK: - Overlay View
extension AddButton: OverlayView {
    
    func shouldBeVisible(for state: Overlay.State) -> Bool {
        switch state {
        case .normal: return true
        default: return false
        }
    }
}
