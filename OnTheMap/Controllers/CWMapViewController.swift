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

struct StudentAnnotation {
    let title: String
    let subTitle: String
    let coord: CLLocationCoordinate2D
}

class CWMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let udacitySingleton = UdacityAPI.sharedInstance
    let parseSingleton = ParseAPI.sharedInstance
    
    var studentLocations: StudentArray = StudentArray(results: []) {
        didSet {
            if !studentLocations.results.isEmpty {
                var tempArray: [StudentAnnotation] = []
                for students in studentLocations.results {
                    
                    if let latitude = students.latitude {
                        if let longitude = students.longitude {
                            let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                            let name = (students.firstName ?? "") + " " + (students.lastName ?? "")
                            let url = students.mediaURL ?? ""
                            tempArray.append(StudentAnnotation(title: name, subTitle: url, coord: coord))
                        }
                    }
                }
                
                self.coordArray.append(contentsOf: tempArray)
            } else {
                print("Getting no data back!")
            }        }
    }
    
    var coordArray: [StudentAnnotation] = [] {
        didSet {
            for studAnnotation in coordArray {
                let annotation = MKPointAnnotation()
                annotation.coordinate = studAnnotation.coord
                annotation.title = studAnnotation.title
                annotation.subtitle = studAnnotation.subTitle
                
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        getData()
    }
    
    @IBAction func addLocation(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    func getData() {
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.startAnimating()
        
        parseSingleton.getStudentLocations(with: {studentLocationArray in
            DispatchQueue.main.async {
                self.studentLocations = studentLocationArray
                activityIndicator.stopAnimating()
            }
        })
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        udacitySingleton.deleteSession()
        dismissSelf()
    }
}
