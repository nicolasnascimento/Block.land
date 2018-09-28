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
    
    // Quick search for parent view controller
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

extension UIView {
    
    /// Get a view from the current hierarchy which is associated
    func newViewOnlyIfNeeded<T>(with tag: Int, allocationBlock: (() -> T)? = nil) -> T where T: UIView {
        if let view = self.viewWithTag(tag) as? T {
            return view
        } else {
            
            // Create new view
            let view = allocationBlock?() ?? T(frame: self.bounds)
            view.tag = tag
            
            return view
        }
    }
}
