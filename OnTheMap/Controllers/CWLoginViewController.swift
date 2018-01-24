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
        postLoginWith(completion: {
            if ($0["error"] != nil) {
                DispatchQueue.main.async {
                    self.presentAlertWith(title: "Invalid Credentials", message: "Please try again")
                }
            }
            
            print($0)
        })
    }
    
    func postLoginWith(completion: @escaping (([String : Any]) -> ())) {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let emailText = self.emailTextField.text else {return}
        guard let passwordText = self.passwordTextField.text else {return}
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".data(using: .utf8, allowLossyConversion: false)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            //print(String(data: data!, encoding: .utf8)!)
            
            guard let data = newData else {print("Something is wrong with the data"); return}
            let jsonResult : [String : Any]
            do {
                jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                completion(jsonResult)
            } catch let jsonErr {
                print("There is an error! \(jsonErr)")
                completion([:])
            }
            
           
        }
        task.resume()
    }
}
