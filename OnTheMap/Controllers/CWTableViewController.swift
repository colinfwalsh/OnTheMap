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
    var parseModel = ParseModel.sharedInstance {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        udacityInstance.deleteSession()
        dismissSelf()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func refresh(_ sender: Any) {
        getData(parentView: self.view, parseInstance: parseInstance) { (studentArray, error) in
            if let studentArray = studentArray {
                self.parseModel.studentArray = studentArray
            } else {
                DispatchQueue.main.async {
                    if let error = error as? CWError {
                        self.presentAlertWith(parentViewController: self, title: error.title, message: error.description)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return parseModel.studentArray.results.count
        
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
        
        if !parseModel.studentArray.results.isEmpty {
            let studentItem = parseModel.studentArray.results[indexPath.row]
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
