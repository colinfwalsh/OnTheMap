//
//  CWLoginViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/22/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit

class CWLoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let apiSingleton = UdacityAPI.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func presentAlertWith(title: String , message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let emailText = self.emailTextField.text else {return}
        guard let passwordText = self.passwordTextField.text else {return}
        
        apiSingleton.postLoginWith(emailText: emailText,
                                   passwordText: passwordText,
                                   with: {credentials in
            if (credentials["error"] != nil) {
                DispatchQueue.main.async {
                    self.presentAlertWith(title: "Invalid Credentials", message: "Please try again")
                }
            }
                                    
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "transitionToTab", sender: credentials)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender {
            print(sender)
        }
    }
}
