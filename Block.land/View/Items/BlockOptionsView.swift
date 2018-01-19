//
//  BlockOptionsView.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 19/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

class BlockOptionsView: UIView {
    
    var isDisplaying: Bool = false {
        didSet {
            if( self.isDisplaying ) {
                self.bottomConstraints.forEach{
                    $0.constant = 10
                }
            } else {
                self.bottomConstraints.forEach{
                    $0.constant = 1000
                }
            }
        }
    }
    
    // The options button array
    private var optionButtons: UIStackView = UIStackView()
    private var bottomConstraints: [NSLayoutConstraint] = []
    
    func setup(with blockOptions: [BlockComponent.BlockMaterialType] = BlockComponent.BlockMaterialType.all) {
        
        // Create options if they're not stored it
        if( !self.optionButtons.arrangedSubviews.isEmpty ) {
            print("Setup was already Performed")
            
        }
        // Create options
        self.createOptionButtons(using: blockOptions)

        // Auto-layout
        self.setupOptionButtonsLayout(using: blockOptions)
        
    }
    
    // MARK: - Private
    private func createOptionButtons(using blockOptions: [BlockComponent.BlockMaterialType]) {
        
        // [Option] -> [Image]
        let images = blockOptions.map{ UIImage(named: $0.rawValue) }
        
        // [Image] -> [Button]
        let optionButtons: [UIButton] = images.map{
            let button = UIButton(frame: .zero)
            button.setImage($0, for: .normal)
            return button
        }
        
        // Add button as subview
        optionButtons.forEach(self.optionButtons.addArrangedSubview)
        
        self.addSubview(self.optionButtons)
    }
    
    private func setupOptionButtonsLayout(using blockOptions: [BlockComponent.BlockMaterialType]) {
        // Setup Constraints
        let sideSpacing: CGFloat = 0
        
        self.optionButtons.heightToSuperview()
        self.optionButtons.bottomToSuperview(offset: sideSpacing)
        self.optionButtons.leadingToSuperview()
        self.optionButtons.trailingToSuperview()
        
        self.optionButtons.spacing = sideSpacing
        
        self.optionButtons.translatesAutoresizingMaskIntoConstraints = false
        
        self.optionButtons.updateLayout()
    }
}
