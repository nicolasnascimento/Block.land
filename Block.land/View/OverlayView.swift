//
//  OverlayView.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 17/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

final class Overlay {

    // MARK: - Public
    
    /// The view in which all other components will be placed
    var view: UIView
    
    // MARK - Initialization
    init(with superView: UIView) {
        
        // Instatiate view of the same size of superview
        self.view = UIView(frame: superView.frame)
        self.view.backgroundColor = .clear
        
        // Debug Layer
        #if DEBUG
            self.view.layer.borderWidth = 1.0
            self.view.layer.borderColor = UIColor.lightGray.cgColor
        #endif
        
        // Add layer view to superView's view hierarchy
        superView.addSubview(self.view)
        print(self.view.frame)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup constraints
        self.view.topAnchor.constraint(equalTo: superView.layoutMarginsGuide.topAnchor).isActive = true
        self.view.leftAnchor.constraint(equalTo:  superView.layoutMarginsGuide.leftAnchor).isActive = true
        self.view.rightAnchor.constraint(equalTo: superView.layoutMarginsGuide.rightAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: superView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        // Update layout
        self.view.setNeedsLayout()
    }
}
