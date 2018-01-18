//
//  UIViewExtensions.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 18/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

extension UIView {
    
    // Schedules layout update and apply it
    func updateLayout() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    // Quick serach for parent view controller
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
