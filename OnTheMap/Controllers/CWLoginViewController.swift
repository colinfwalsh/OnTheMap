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
    let parseModel = ParseModel.sharedInstance
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
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        let dispatchGroup = DispatchGroup()
        var errorVal: CWError!
        
        dispatchGroup.enter()
        udacityInstance.postLoginWith(emailText: emailText,
                                      passwordText: passwordText,
                                      with: {(credentials, error) in
                                        if error != nil {
                                            errorVal = error
                                        }
                                        
                                        if let status = credentials?.status {
                                            errorVal = status != 400 ? CWError.invalidCredentials : CWError.serverError
                                        } else {
                                            self.udacityModel.credentials = credentials
                                        }
                                        dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        parseInstance.getStudentLocations { (studentArray, error) in
            if let studentArray = studentArray {
                self.parseModel.studentArray = studentArray
            } else {
                errorVal = CWError.serverError
            }
        
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            activityIndicator.stopAnimating()
            print(errorVal)
            if errorVal != nil {
                self.presentAlertWith(parentViewController: self, title: errorVal.title, message: errorVal.description)
            } else {
                self.performSegue(withIdentifier: "transitionToTab", sender: self)
            }
        }
        
        
    }
}

extension CWLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
