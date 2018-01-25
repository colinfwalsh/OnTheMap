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
    
    let udacitySingleton = UdacityAPI.sharedInstance
    let parseSingleton = ParseAPI.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        udacitySingleton.postLoginWith(emailText: emailText,
                                       passwordText: passwordText,
                                       with: {(credentials, error) in
                                        if (credentials["error"] != nil) {
                                            DispatchQueue.main.async {
                                                activityIndicator.stopAnimating()
                                                self.presentAlertWith(parentViewController: self, title: "Invalid Credentials", message: "Please try again")
                                            }
                                        }
                                        
                                        DispatchQueue.main.async {
                                            activityIndicator.stopAnimating()
                                            self.performSegue(withIdentifier: "transitionToTab", sender: credentials)
                                        }
                                        
        })
    }
}
