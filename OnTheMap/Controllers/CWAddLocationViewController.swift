//
//  CWAddLocationViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/25/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit
import CoreLocation

class CWAddLocationViewController: UIViewController, HelperProtocol {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    let udacityModel = UdacityModel.sharedInstance
    let udacityAPI = UdacityAPI()
    let parseAPI = ParseAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribe()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if websiteTextField.isFirstResponder {
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
    
    @IBAction func findLocation(_ sender: Any) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        verifyStudentData(locationString: locationTextField.text!, urlString: websiteTextField.text!, completion: {model,error in
            
            DispatchQueue.main.async {
                if error != nil {
                    let error = error as! CWError
                    activityIndicator.stopAnimating()
                    self.presentAlertWith(parentViewController: self, title: error.title, message: error.description)
                    return
                } else {
                    activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "toPostLocation", sender: model)
                }
            }
        })
    }
    
    func verifyStudentData(locationString: String, urlString: String, completion: @escaping (StudentStagingModel?, Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        let key = (udacityModel.credentials.account?.key)!
        dispatchGroup.enter()
        var firstName: String!
        var lastName: String!
        
        if !self.verifyURL(string: urlString) {
            completion(nil, CWError.urlError)
            return
        }
        
        udacityAPI.getUserData(userId: key, with: {
            
            if $1 != nil {
                completion(nil, CWError.userDataError)
                return
            }
            
            guard let user = $0?.user else {return}
            
            firstName = user.first_name
            lastName =  user.last_name
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        var mapString: String!
        let geocoder = CLGeocoder()
        var lat : Double!
        var long : Double!
        geocoder.geocodeAddressString(locationString, completionHandler: {
            if $1 != nil {
                completion(nil, CWError.locationError)
                return
            }
            
            guard let placeMark = $0 else {return}
            guard let locality = placeMark[0].locality else {return}
            guard let state = placeMark[0].administrativeArea else {return}
            guard let location = placeMark[0].location else {return}
            
            mapString = String(describing: locality + ", " + state)
            lat = Double(location.coordinate.latitude)
            long = Double(location.coordinate.longitude)
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main, execute: {
            let stage = StudentStagingModel(uniqueKey: key, firstName: firstName, lastName: lastName, mapString: mapString, mediaUrl: urlString, latitude: lat, longitude: long)
            completion(stage, nil)
        })
    }

    func verifyURL(string: String) -> Bool {
        if string.range(of: "http://") != nil || string.range(of: "https://") != nil {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CWFinishLocationViewController
        destination.stagingModel = sender as! StudentStagingModel
    }
}

struct StudentStagingModel {
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaUrl: String
    let latitude: Double?
    let longitude: Double?
}

