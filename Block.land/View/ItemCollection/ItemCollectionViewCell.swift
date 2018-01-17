//
//  ItemCollectionViewCell.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 17/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {
    
    // Lazily create image for cell
    private lazy var itemImageView: UIImageView = {
        
        // Create Item Image View
        let spacing = 10.0 as CGFloat
        let bounds = CGRect(x: spacing, y: spacing, width: self.bounds.width - 2.0*spacing, height: self.bounds.height - 2.0*spacing)
        let imageView = UIImageView(frame: bounds)
        
        // Add to Cell
        self.addSubview(imageView)
        
        // Auto Layout
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.edges(to: self, insets: insets)
        
        // Return reference
        return imageView
    }()
    
    // Add required views performs drawing
    func setup(for item: BlockComponent.BlockMaterialType) {
        
        // Simply set appropriate image
        self.itemImageView.image = UIImage(named: item.rawValue)
    }
}
