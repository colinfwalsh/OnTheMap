//
//  CWMapViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/22/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CWMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let udacitySingleton = UdacityAPI.sharedInstance
    let parseSingleton = ParseAPI.sharedInstance
    
    var studentLocations: StudentArray = StudentArray(results: []) {
        didSet {
            if !studentLocations.results.isEmpty {
                var tempArray: [CLLocationCoordinate2D] = []
                for students in studentLocations.results {
                    
                    if let latitude = students.latitude {
                        if let longitude = students.longitude {
                            let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                            tempArray.append(coord)
                        }
                    }
                }
                
                self.coordArray.append(contentsOf: tempArray)
            } else {
                print("Getting no data back!")
            }        }
    }
    
    var coordArray: [CLLocationCoordinate2D] = [] {
        didSet {
            for coord in coordArray {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coord
                self.mapView.addAnnotation(annotation)
            }
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
        dismissSelf()
    }
}
