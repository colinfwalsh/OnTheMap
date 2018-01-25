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
}
