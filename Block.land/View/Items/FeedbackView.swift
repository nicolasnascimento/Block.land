//
//  TrackingStateView.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 20/03/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

final class FeedbackView: UIView {
    
    // MARK: - Private Properties
    private var feedbackLabel: UILabel { return self.newViewOnlyIfNeeded(with: 8888) }
    private var backgroundView: UIView { return self.newViewOnlyIfNeeded(with: 8889) }
    
    // MARK: - Public Properties
    var color: UIColor = .lightGray             { didSet { self.setup() } }
    var feedbackText: String = "No Feedback"    { didSet { self.setup() } }
    
    
    func setup() {
        // Get label and background view
        let textLabel: UILabel = self.feedbackLabel
        let backgroundView: UIView = self.backgroundView

        textLabel.text = self.feedbackText
        
        backgroundView.backgroundColor = color
        backgroundView.layer.cornerRadius = 10
    }
}
