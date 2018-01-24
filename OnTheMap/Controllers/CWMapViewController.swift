//
//  CWMapViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/22/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit

class CWMapViewController: UIViewController {
    
    let apiSingleton = UdacityAPI.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutTapped(_ sender: Any) {
        apiSingleton.deleteSession()
        backToLogin()
    }
    
    func backToLogin() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
