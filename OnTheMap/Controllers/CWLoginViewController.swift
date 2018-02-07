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
    @IBOutlet weak var loginButton: UIButton!
    
    let udacityInstance = UdacityAPI()
    let parseInstance = ParseAPI()
    var udacityModel = UdacityModel.sharedInstance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if passwordTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)/4
        } else {
            view.frame.origin.y -= getKeyboardHeight(notification)/6
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
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
                                                if let credentials = credentials {
                                                    self.udacityModel.credentials = credentials
                                                    activityIndicator.stopAnimating()
                                                    self.performSegue(withIdentifier: "transitionToTab", sender: (Any).self)
                                                } else {
                                                    self.presentAlertWith(parentViewController: self, title: "No internet", message: "Please connect to the internet and try again")
                                                    activityIndicator.stopAnimating()
                                                }
                                                
                                            }
                                        }
                                        
        })
    }
}

extension CWLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
