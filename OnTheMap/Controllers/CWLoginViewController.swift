//
//  CWLoginViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/22/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit

class CWLoginViewController: UIViewController, HelperProtocol {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let udacityInstance = UdacityAPI()
    let parseInstance = ParseAPI()
    var udacityModel = UdacityModel.sharedInstance
    
    @IBAction func signUp(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    //MARK: ADD ACTIVITY INDICATOR AND IMPLEMENT FAILURE TO CONNECT STATUS
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let emailText = self.emailTextField.text else {return}
        guard let passwordText = self.passwordTextField.text else {return}
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        udacityInstance.postLoginWith(emailText: emailText,
                                       passwordText: passwordText,
                                       with: {(credentials, error) in
                                        
                                        if let status = credentials?.status {
                                            DispatchQueue.main.async {
                                                activityIndicator.stopAnimating()
                                                status != 400 ? self.presentAlertWith(parentViewController: self, title: "Network Error", message: "Cannot connect to the internet") : self.presentAlertWith(parentViewController: self, title: "Invalid Credentials", message: "Please try again")
                                                
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.udacityModel.credentials = credentials!
                                                activityIndicator.stopAnimating()
                                                self.performSegue(withIdentifier: "transitionToTab", sender: (Any).self)
                                            }
                                        }
                                        
        })
    }
}
