//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 11/09/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        if emailText.text == "" && passwordText.text == "" {
            showError(message: "Please Enter username and password")
            setLoggingIn(false)
            return
        }
        API.login(username: emailText.text ?? "", password: passwordText.text ?? "", completion: handlerLoginResponse(success:error:))
    }
    
    func handlerLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "LoginSuccessfull", sender: nil)
        } else {
            showError(message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailText.isEnabled = !loggingIn
        passwordText.isEnabled = !loggingIn
        login.isEnabled = !loggingIn
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        return true
    }
}
