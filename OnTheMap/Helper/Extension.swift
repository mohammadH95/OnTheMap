//
//  Extension.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 11/10/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
