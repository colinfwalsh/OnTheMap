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
        verifyStudentData(locationString: locationTextField.text!, urlString: websiteTextField.text!, completion: {
            self.parseAPI.postStudentLocation(studentInfo: $0, with: { print($0)})
        })
    }
    
    
    func verifyStudentData(locationString: String, urlString: String, completion: @escaping (StudentStagingModel) -> Void) {
        let dispatchGroup = DispatchGroup()
        let key = (udacityModel.credentials.account?.key)!
        dispatchGroup.enter()
        var firstName: String!
        var lastName: String!
        udacityAPI.getUserData(userId: key, with: {
            
            if $1 != nil {
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
        
        if !verifyURL(string: urlString) {
            presentAlertWith(parentViewController: self, title: "Invalid URL", message: "Cannot add the url.  Please add 'http://' or https://")
        }
        
        dispatchGroup.notify(queue: .main, execute: {
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
}

/*
 \"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}
 */

struct StudentStagingModel {
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaUrl: String
    let latitude: Double?
    let longitude: Double?
}

