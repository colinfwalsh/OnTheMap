//
//  CWAddLocationViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/25/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit

class CWAddLocationViewController: UIViewController {
    
    let udacityModel = UdacityModel.sharedInstance
    let udacityAPI = UdacityAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func findLocation(_ sender: Any) {
        udacityAPI.getUserData(userId: (udacityModel.credentials.account?.key)!, with: {
            print($0, $1)
        })
    }
    
}
