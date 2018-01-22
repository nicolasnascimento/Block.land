//
//  Alert.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 22/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

final class Alert {
    
    static var currentViewController: UIViewController? {
        
        // Get view controller being presented now
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        return nil
    }
    
    class func error(with message: String, confirmationHandler: @escaping () -> Void) {
     
        let confirmationAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            guard let alert = Alert.currentViewController?.presentedViewController as? UIAlertController else { fatalError("Cannot dismiss if no alert is being presented") }
            
            alert.dismiss(animated: true) {
                confirmationHandler()
            }
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(confirmationAction)
        Alert.present(alertController: alertController)
        
    }
    
    
    // MARK: - Private
    class func present(alertController: UIAlertController, completionHandler: (() -> Void)? = nil) {
        Alert.currentViewController?.present(alertController, animated: true) {
            completionHandler?()
        }
    }
}
