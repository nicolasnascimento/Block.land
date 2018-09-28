//
//  BlockOptionsView.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 19/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

protocol BlockOptionsViewDelegate: class {
    func blockOptionsView(_ blockOptionView: BlockOptionsView, didSelect option: BlockComponent.BlockMaterialType)
}

final class BlockOptionsView: UIView {
    
    // Delegate
    weak var delegate: BlockOptionsViewDelegate?
    
    // Set default values. This will be overriden later
    var controlConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var controlConstantValue: CGFloat = 0
    
    // The options button array
    private let noIndexTag = -1
    private var optionButtons: UIStackView = UIStackView()
    private var blockOptions: [BlockComponent.BlockMaterialType] = []
    
    func setup(with blockOptions: [BlockComponent.BlockMaterialType] = BlockComponent.BlockMaterialType.all) {
        
        // Store Options
        self.blockOptions = blockOptions
        
        // Create options if they're not stored it
        if !self.optionButtons.arrangedSubviews.isEmpty {
            print("Setup was already Performed")
            
        }
        // Create Options
        self.createOptionButtons(using: blockOptions)

        // Auto-layout
        self.setupOptionButtonsLayout(using: blockOptions)

        // Setup delegate callback
        self.setupCallbackForOptions()
        
    }
    
    // MARK: - Private
    private func createOptionButtons(using blockOptions: [BlockComponent.BlockMaterialType]) {
        
        // [Option] -> [Image]
        let images = blockOptions.map { UIImage(named: $0.rawValue) }
        
        // [Image] -> [Button]
        let optionButtons: [UIButton] = images.map { image in
            let button = UIButton(frame: .zero)
            button.setImage(image, for: .normal)
            
            // Use the index of the image associated with the button.
            // This allows to use the index later in the callback
            button.tag = images.index { $0 == image } ?? self.noIndexTag
            
            return button
        }
        
        // Add button as subview
        optionButtons.forEach(self.optionButtons.addArrangedSubview)
        
        // Add as subview
        self.addSubview(self.optionButtons)
    }
    
    private func setupOptionButtonsLayout(using blockOptions: [BlockComponent.BlockMaterialType]) {
        // Configuration Values
        let buttonSideSpacing: CGFloat = 10
        let buttonCornerRadius: CGFloat = 10
        let buttonBorderWidth: CGFloat = 1.0
        let buttonBorderColor: CGColor = UIColor.white.cgColor
        let buttonMasksToBounds: Bool = true
        
        // Setup Constraints
        self.optionButtons.heightToSuperview()
        self.optionButtons.bottomToSuperview(offset: buttonSideSpacing)
        self.optionButtons.leadingToSuperview(offset: buttonSideSpacing)
        self.optionButtons.trailingToSuperview(offset: buttonSideSpacing)
        
        // Configure StackView
        self.optionButtons.spacing = buttonSideSpacing
        self.optionButtons.distribution = .fillEqually
        
        // Avoid unwanted contraints
        self.optionButtons.translatesAutoresizingMaskIntoConstraints = false
        
        // Update Layout
        self.optionButtons.updateLayout()
        
        // Now we can set the Layer
        self.optionButtons.arrangedSubviews.forEach {
            $0.layer.cornerRadius = buttonCornerRadius
            $0.layer.borderColor = buttonBorderColor
            $0.layer.borderWidth = buttonBorderWidth
            $0.layer.masksToBounds = buttonMasksToBounds
        }
    }
    
    private func setupCallbackForOptions() {
        
        for button: UIButton in self.optionButtons.arrangedSubviews as? [UIButton] ?? [] {
            button.addTarget(self, action: #selector(self.buttonTouched(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Actions
    @objc private func buttonTouched(_ button: UIButton) {
        if button.tag != self.noIndexTag {
            self.delegate?.blockOptionsView(self, didSelect: self.blockOptions[button.tag])
        } else {
            print("Error, button has no associated tag, no callback will be providede")
        }
    }
    
}

extension BlockOptionsView: OverlayView {

    func shouldBeVisible(for state: Overlay.State) -> Bool {
        switch state {
        case .editingBlock: return true
        default: return false
        }
    }
    
}
