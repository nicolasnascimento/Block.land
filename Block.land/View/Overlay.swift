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
    func overlay(_ overlay: Overlay, didSelect option: BlockComponent.BlockMaterialType)
}

/// Manages the components displayed in the view
final class Overlay {
    
    // MARK: - Public
    
    // The delegate to which overlay related events will be sent
    weak var delegate: OverlayDelegate?
    
    // The states in which the overlay may be
    enum State {
        case normal
        case editingBlock
        case unknown
    }
    /// The state of the overlay
    var state: State = .unknown {
        willSet {
            // Only Update if the state is a new one
            if( self.state != newValue ) {
                self.update(for: newValue)
            }
        }
    }

    // MARK: - Private Properties
    
    /// The view in which all other components will be placed
    private(set) var view: UIView
    
    /// The button used to perform add action
    private var addButton: AddButton
    
    /// The view which will be used to provide focus
    private var focusCircle: FocusView
    
    /// The view which will be used for displaying block options
    private var blockOptions: BlockOptionsView
    
    // MARK: - Init
    init(with superView: UIView) {
        
        // Instatiate properties to default values
        self.view = UIView(frame: .zero)
        self.addButton = AddButton(frame: .zero)
        self.focusCircle = FocusView(frame: .zero)
        self.blockOptions = BlockOptionsView(frame: .zero)
        
        // Setup View
        self.setupView(for: superView)
        
        // Setup Add Button
        self.setupAddButton(for: self.view)
        
        // Setup Focus Circle
        self.setupFocusCircle(for: self.view)
        
        // Setup Block Options
        self.setupBlockOptions(for: self.view)
        
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
        
        // Keep a reference as we'll need to update this later
        self.addButton.controlConstraint = self.addButton.bottomToSuperview(offset: -bottomSpacing)
        self.addButton.controlConstantValue = -bottomSpacing
 
        // Update Layout
        self.addButton.updateLayout()
        
        // Update drawing
        self.addButton.setNeedsDisplay()
        
        // Setup Delegate callback
        self.addButton.addTarget(self, action: #selector(self.addButtonDidGetPressed(_:)), for: .touchUpInside)
    }
    private func setupFocusCircle(for superView: UIView) {
        // Add layer view to superView's view hierarchy
        superView.addSubview(self.focusCircle)
        
        // Control values for setting up layout
        let referenceSize = CGSize(width: 10, height: 10)
        
        // Setup Constraints
        self.focusCircle.centerInSuperview()
        self.focusCircle.size(referenceSize)
        
        // Update Layout
        self.focusCircle.updateLayout()
        
        // Redraw Frame
        self.focusCircle.setNeedsDisplay()
        self.focusCircle.backgroundColor = UIColor.clear
    }
    private func setupBlockOptions(for superView: UIView) {
        // Add layer view to superView's view hierarchy
        superView.addSubview(self.blockOptions)
        
        // Avoid unwanted constraints
        self.blockOptions.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup buttons
        self.blockOptions.setup()
        
        // Control values for setting up layout
        let heightMultiplier: CGFloat = 0.1
        let widthMultiplier: CGFloat = 1.0
        let bottomSpacing: CGFloat = superView.frame.height*heightMultiplier*0.25
        
        // Setup Constrains
        self.blockOptions.heightToSuperview(multiplier: heightMultiplier)
        self.blockOptions.widthToSuperview(multiplier: widthMultiplier)
        self.blockOptions.centerX(to: superView)
        
        // Keep a reference as we'll need to update this later
        self.blockOptions.controlConstraint = self.blockOptions.bottomToSuperview(offset: -bottomSpacing)
        self.blockOptions.controlConstantValue = -bottomSpacing
        
        // Update Layout
        self.blockOptions.updateLayout()
    
        // Setup Default State
        self.blockOptions.backgroundColor = .clear
        
        // Setup Delegate Callback
        self.blockOptions.delegate = self
    }
    
    private func update(for state: State) {
        // The views which can be updated
        for view: OverlayView in [self.addButton, self.blockOptions, self.focusCircle] {
            if( view.shouldBeVisible(for: state) ) {
                view.show()
            } else {
                view.hide()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func addButtonDidGetPressed(_ addButton: UIButton) {
        self.delegate?.overlay(self, didPressAdd: addButton)
    }
}

extension Overlay: BlockOptionsViewDelegate {
    func blockOptionsView(_ blockOptionView: BlockOptionsView, didSelect option: BlockComponent.BlockMaterialType) {
        self.delegate?.overlay(self, didSelect: option)
    }
}
