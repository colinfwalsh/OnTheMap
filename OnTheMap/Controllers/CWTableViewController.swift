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
    
    var studentLocations: StudentArray = StudentArray(results: []) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseSingleton.getStudentLocations(with: {studentLocationArray in
            DispatchQueue.main.async {
                self.studentLocations = studentLocationArray
            }
        })
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        udacitySingleton.deleteSession()
        self.dismissSelf()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.results.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cwCell", for: indexPath) as! CWTableViewCell
        
        if !studentLocations.results.isEmpty {
            let studentItem = studentLocations.results[indexPath.row]
            cell.nameLabel.text = (studentItem.firstName ?? "") + " " + (studentItem.lastName ?? "")
            cell.urlLabel.text = studentItem.mediaURL ?? ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
