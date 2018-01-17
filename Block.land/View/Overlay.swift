//
//  OverlayView.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 17/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit
import TinyConstraints

final class Overlay {

    // MARK: - Public
    
    /// The view in which all other components will be placed
    var view: UIView
    
    // This will get created after all the view frame is set
    private(set) var itemCollection: ItemCollection
    
    // MARK - Initialization
    init(with superView: UIView) {
        
        // Instatiate properties to default values
        self.view = UIView(frame: superView.frame)
        self.itemCollection = ItemCollection()
        
        // Setup View
        self.setupView(for: superView)
        
        // Setup collection view
        self.itemCollection.setupCollectionView(for: self.view)
        
        // Display items
        self.itemCollection.reload()
    }
    
    // MARK: - Private
    private func setupView(for superView: UIView) {
        self.view.backgroundColor = .clear
        
        // Debug Layer
        #if DEBUG
            self.view.layer.borderWidth = 1.0
            self.view.layer.borderColor = UIColor.lightGray.cgColor
        #endif

        // Add layer view to superView's view hierarchy
        superView.addSubview(self.view)
        
        // Avoid unwanted constrainst
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup constraints
        self.view.edgesToSuperview()
        
        // Update layout
        self.view.setNeedsLayout()
        
    }
}
