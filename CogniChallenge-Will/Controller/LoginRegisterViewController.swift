//
//  LoginRegisterViewController.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import UIKit
import Foundation

class LoginRegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signUpButton: RoundedButtonWithBorder!
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                startLoadingIndicator()
            } else {
                stopLoadingIndicator()
            }
        }
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        let username = usernameTextfield?.text
        let email = emailTextfield?.text
        isLoading = true
        
        NetworkManager.sharedInstance.userLoginOrRegister(username: username!, email: email!, userCase: .login) { [unowned self](result) in
            self.isLoading = false
            switch result {
            case .success( _):
                self.dismiss(animated: true, completion: {
                    self.stopLoadingIndicator()
                })
            case .failure(let error):
                self.presentError(message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        let username = usernameTextfield?.text
        let email = emailTextfield?.text
        
        isLoading = true
        
        NetworkManager.sharedInstance.userLoginOrRegister(username: username!, email: email!, userCase: .register) { [unowned self](result) in
            self.isLoading = false
            switch result {
            case .success( _):
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.presentError(message: error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingActivityIndicator.isHidden = true
    }
    
    private func startLoadingIndicator() {
        
        signUpButton.titleLabel?.isHidden = true
    
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
    }
    
    private func stopLoadingIndicator() {
        
        signUpButton.titleLabel?.isHidden = false
        
        loadingActivityIndicator.stopAnimating()
        loadingActivityIndicator.isHidden = true
    }
    
}
