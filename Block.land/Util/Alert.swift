//
//  Alert.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 22/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum AlertType {
        case error(String)
    }
    
    func presentAlert(with type: AlertType, confirmationHandler: (() -> Void)? = nil) {
    
        switch type {
        case .error(let message):
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
            if let handler = confirmationHandler {
                alertController.addAction(self.confirmationAction(with: handler))
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private
    private func confirmationAction(with handler: @escaping () -> Void) -> UIAlertAction {
        return UIAlertAction(title: "Ok", style: .default) { _ in
            handler()
        }
    }
    
}
