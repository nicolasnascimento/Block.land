//
//  OverlayView.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 17/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit
import TinyConstraints

// Implement these methods to get callbacks when button in the overlay are pressed
protocol OverlayDelegate: class {
    func overlay(_ overlay: Overlay, didPressAdd button: UIButton)
}

final class Overlay {
    
    // MARK: - Public
    
    // The delegate to which overlay related events will be sent
    weak var delegate: OverlayDelegate?
    
    /// The view in which all other components will be placed
    var view: UIView
    
    // MARK: - Private
    
    /// The button used to perform add action
    private var addButton: UIButton
    
    // MARK - Initialization
    init(with superView: UIView) {
        
        // Instatiate properties to default values
        self.view = UIView(frame: .zero)
        self.addButton = UIButton(frame: .zero)
        
        // Setup View
        self.setupView(for: superView)
        
        // Setup Add Button
        self.setupAddButton(for: self.view)
    }
    
    // MARK: - Private
    private func setupView(for superView: UIView) {
        // No background color will be used, so set it .clear
        self.view.backgroundColor = .clear
        
        // Debug Layer
        if( Environment.debugMode ) {
            self.view.layer.borderWidth = 1.0
            self.view.layer.borderColor = UIColor.lightGray.cgColor
        }

        // Add layer view to superView's view hierarchy
        superView.addSubview(self.view)
        
        // Avoid unwanted constrainst
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup constraints
        self.view.edgesToSuperview()
        
        // Update layout
        self.view.updateLayout()
    }
    private func setupAddButton(for superView: UIView) {
        // Add layer view to superView's view hierarchy
        superView.addSubview(self.addButton)
        
        // Set Image (Normal)
        let addButtonImageName = "add"
        self.addButton.setImage(UIImage(named: addButtonImageName), for: .normal)
        self.addButton.imageView?.contentMode = .scaleAspectFit
        
        // Control values for setting up layout
        let heightMultiplier: CGFloat = 0.1
        let widthMultiplier: CGFloat = 0.3
        let bottomSpacing: CGFloat = superView.frame.height*heightMultiplier*0.25
        
        // Setup Constrains
        self.addButton.heightToSuperview(multiplier: heightMultiplier)
        self.addButton.widthToSuperview(multiplier: widthMultiplier)
        self.addButton.centerX(to: superView)
        self.addButton.bottomToSuperview(offset: -bottomSpacing)
 
        // Update Layout
        self.addButton.updateLayout()
        
        // Setup Delegate callback
        self.addButton.addTarget(self, action: #selector(self.addButtonDidGetPressed(_:)), for: .touchUpInside)
    }
    @objc private func addButtonDidGetPressed(_ addButton: UIButton) {
        self.delegate?.overlay(self, didPressAdd: addButton)
    }
}
