//
//  CWTableViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/22/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit

class CWTableViewController: UITableViewController {
    
    let udacitySingleton = UdacityAPI.sharedInstance
    let parseSingleton = ParseAPI.sharedInstance
    
    var studentLocations: StudentArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        udacitySingleton.deleteSession()
        dismissSelf()
    }
    
    private func dismissSelf() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.results.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cwCell", for: indexPath) as! CWTableViewCell
        
        cell.nameLabel.text = "Name"
        cell.urlLabel.text = "Url"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
