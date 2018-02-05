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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func findLocation(_ sender: Any) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.startAnimating()
        verifyStudentData(activityIndicator: activityIndicator, locationString: locationTextField.text!, urlString: websiteTextField.text!, completion: {model in
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toPostLocation", sender: model)
            }
            /*
             self.parseAPI.postStudentLocation(studentInfo: $0, with: { print($0)})*/
        })
    }
    
    
    func verifyStudentData(activityIndicator: UIActivityIndicatorView, locationString: String, urlString: String, completion: @escaping (StudentStagingModel) -> Void) {
        let dispatchGroup = DispatchGroup()
        let key = (udacityModel.credentials.account?.key)!
        dispatchGroup.enter()
        var firstName: String!
        var lastName: String!
        
        DispatchQueue.main.async {
            if !self.verifyURL(string: urlString) {
                self.presentAlertWith(parentViewController: self, title: "Invalid URL", message: "Cannot add the url.  Please add 'http://' or https://")
            }
        }
        
        udacityAPI.getUserData(userId: key, with: {
            
            if $1 != nil {
                DispatchQueue.main.async {
                    self.presentAlertWith(parentViewController: self, title: "Error", message: "There was an error fetching the user data, please check your network connection and try again.")
                }
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
                DispatchQueue.main.async {
                    self.presentAlertWith(parentViewController: self, title: "Error", message: "Could not parse location entered.  Try another location or check your spelling.")
                }
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
            activityIndicator.stopAnimating()
            let stage = StudentStagingModel(uniqueKey: key, firstName: firstName, lastName: lastName, mapString: mapString, mediaUrl: urlString, latitude: lat, longitude: long)
            completion(stage)
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

