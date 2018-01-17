//
//  ItemCollection.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 17/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

final class ItemCollectionFlowLayoutManager {

    // A default layout to be used in the item collection view
    let layout: UICollectionViewFlowLayout
    
    init() {
        self.layout = UICollectionViewFlowLayout()
        
        // Set default values
        layout.itemSize = CGSize(width: 1, height: 1)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    func update(for size: CGSize, insets: UIEdgeInsets, numberOfItems: Int) {

        // Calculate new proportions
        let flowLayout = self.layout
        let width = size.width*1.023/CGFloat(numberOfItems)
        let height = size.height*0.15 - (insets.bottom)

        flowLayout.itemSize = CGSize(width: width, height: height)

        // Update layout
        flowLayout.invalidateLayout()
    }
}

protocol ItemCollectionDelegate: class {
    func itemCollection(_ itemCollection: ItemCollection, didSelect item: BlockComponent.BlockMaterialType)
}

final class ItemCollection: NSObject {
    
    // Delegate
    weak var delegate: ItemCollectionDelegate?

    // The Collection View to display items
    var collectionView: UICollectionView
    
    // The items to be displayed in the collection view
    private let items = BlockComponent.BlockMaterialType.all
    
    private let itemCellClass: AnyClass = ItemCollectionViewCell.self
    private let itemCellReuseIdentifier = "ItemCollectionViewCell"
    private let itemLayoutManager = ItemCollectionFlowLayoutManager()
    
    // MARK: - Initialization
    override init() {
        
        // Init collection view
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: itemLayoutManager.layout)
        
        // Perform super class initialization
        super.init()
    }
    
    func reload() {
        // Update Collection View Data
        self.collectionView.reloadData()

        // Update frame height
        self.collectionView.setNeedsLayout()
        
        // Update Cell Size
        guard let superView = self.collectionView.superview else { return }
        self.reloadFlowLayout(for: superView)
    }
    
    // MARK: - Public
    /// This should be called to
    func setupCollectionView(for superView: UIView) {
        
        self.collectionView.backgroundColor = .clear
        
        // Add Collection View to Superview's View Hierarchy
        superView.addSubview(self.collectionView)
        
        // Register Cell class
        self.collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: self.itemCellReuseIdentifier)
        
        // Auto-Layout
        let insets = self.edgeInsets(for: superView)
        self.collectionView.edges(to: superView, insets: insets)
        self.collectionView.setNeedsLayout()
        
        // Set Delegate & Data Source
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // MARK: - Private
    private func edgeInsets(for superView: UIView) -> UIEdgeInsets {
        let edgeSpacing = 15 as CGFloat
        return UIEdgeInsets(top: superView.bounds.size.height*0.88, left: edgeSpacing, bottom: -edgeSpacing, right: -edgeSpacing)
    }
    
    private func reloadFlowLayout(for superView: UIView) {
        let insets = self.edgeInsets(for: superView)
        self.itemLayoutManager.update(for: superView.bounds.size, insets: insets, numberOfItems: self.items.count)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension ItemCollection: UICollectionViewDataSource, UICollectionViewDelegate {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.itemCellReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        
        cell.setup(for: self.items[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.itemCollection(self, didSelect: self.items[indexPath.row])
    }
}
