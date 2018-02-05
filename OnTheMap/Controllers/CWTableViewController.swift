//
//  CWTableViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/22/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit

class CWTableViewController: UITableViewController, HelperProtocol {
    
    let udacityInstance = UdacityAPI()
    let parseInstance = ParseAPI()
    let udacityModel = UdacityModel.sharedInstance
    
    var studentLocations: StudentArray = StudentArray(results: []) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(parentView: self.view, parseSingleton: parseInstance, with: {(studentArray, error) in
            
            if let error = error as? CWError {
                DispatchQueue.main.async {
                    self.presentAlertWith(parentViewController: self, title: error.title, message: error.description)
                }
            } else {self.studentLocations = studentArray!}
        })
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        udacityInstance.deleteSession()
        dismissSelf()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func refresh(_ sender: Any) {
       getData(parentView: self.view, parseSingleton: parseInstance, with: {(studentArray, error) in
        
            if let error = error as? CWError {
                DispatchQueue.main.async {
                    self.presentAlertWith(parentViewController: self, title: error.title, message: error.description)
                }
            } else {
                self.studentLocations = studentArray!
        }
        
       
       })
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        let getStudentCount = studentLocations.results.count
        return getStudentCount <= 100 ? getStudentCount : 100
        
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CWTableViewCell
        
        checkAndOpen(parentViewController: self, urlString: cell.urlLabel.text!)
        
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cwCell",
                                                 for: indexPath) as! CWTableViewCell
        
        if !studentLocations.results.isEmpty {
            let studentItem = studentLocations.results[indexPath.row]
            cell.nameLabel.text = (studentItem.firstName ?? "") + " " + (studentItem.lastName ?? "")
            cell.urlLabel.text = studentItem.mediaURL ?? ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
