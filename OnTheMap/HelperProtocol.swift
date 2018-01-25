//
//  HelperProtocol.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/25/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation
import UIKit

protocol HelperProtocol {
    
}

extension HelperProtocol {
    func getData(parentView: UIView, parseSingleton: ParseAPI, with completion: @escaping (StudentArray) -> Void) {
        
        let activityIndicator = UIActivityIndicatorView()
        
        OperationQueue.main.addOperation {
            activityIndicator.activityIndicatorViewStyle = .gray
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = parentView.center
            parentView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        
        parseSingleton.getStudentLocations(with: {(studentLocationArray, error) in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                if let studentLocationArray = studentLocationArray {
                    completion(studentLocationArray)
                } else {
                    print(error!)
                }
            }
        })
    }
    
    func checkAndOpen(parentViewController: UIViewController, urlString: String) {
        let app = UIApplication.shared
        
        guard let url = URL(string: urlString) else {return}
        
        if app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
        } else {
            presentAlertWith(parentViewController: parentViewController, title: "Invalid URL", message: "Cannot access \"\(urlString)\", try a different url")
        }
    }
    
    func presentAlertWith(parentViewController: UIViewController, title: String , message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        parentViewController.present(alert, animated: true, completion: nil)
    }
}
