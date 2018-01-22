//
//  MainViewController.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 16/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit
import ARKit

final class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var sceneView: ARSCNView!
   
    // MARK: - Public
    var coordinator: Coordinator!
    
    var overlay: Overlay!
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Overlay and add its view
        self.overlay = Overlay(with: self.sceneView)
        
        // Create coordinator
        self.coordinator = Coordinator(overlay: self.overlay)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Begin coordinator
        self.coordinator.begin()
        
    }

}
