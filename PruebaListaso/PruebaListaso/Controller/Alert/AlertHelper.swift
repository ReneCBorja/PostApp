//
//  ALertHelper.swift
//  PruebaListaso
//
//  Created by user273444 on 12/20/24.
//

import UIKit

@objc class AlertHelper: NSObject {
 @objc   static func showAlert(on viewController: UIViewController, withMessage message: String) {
        let alert = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alert.addAction(acceptAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
