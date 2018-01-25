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

class CWMapViewController: UIViewController, HelperProtocol, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let udacitySingleton = UdacityAPI()
    let parseSingleton = ParseAPI()
    let udacityModel = UdacityModel.sharedInstance
    
    var studentLocations: StudentArray = StudentArray(results: []) {
        didSet {setCoordArray()}
    }
    
    var coordArray: [StudentAnnotation] = [] {
        didSet {addAnnotations()}
    }
    
    private func setCoordArray() {
        if !studentLocations.results.isEmpty {
            var tempArray: [StudentAnnotation] = []
            for students in studentLocations.results {
                
                if let latitude = students.latitude {
                    if let longitude = students.longitude {
                        let coord: CLLocationCoordinate2D =
                            CLLocationCoordinate2D(
                                latitude: CLLocationDegrees(latitude),
                                longitude: CLLocationDegrees(longitude))
                        let name = (students.firstName ?? "FIRST") +
                            " " + (students.lastName ?? "LAST")
                        let url = students.mediaURL ?? "URL"
                        tempArray.append(StudentAnnotation(title: name,
                                                           subTitle: url,
                                                           coord: coord))
                    }
                }
            }
            
            tempArray.count <= 100 ?
                self.coordArray.append(contentsOf: tempArray) :
                self.coordArray.append(contentsOf: tempArray[0...99])
        } else {
            print("Getting no data back!")
        }
    }
    
    private func addAnnotations() {
        var annotationArray: [MKPointAnnotation] = []
        for studAnnotation in coordArray {
            let annotation = MKPointAnnotation()
            annotation.coordinate = studAnnotation.coord
            annotation.title = studAnnotation.title
            annotation.subtitle = studAnnotation.subTitle
            
            annotationArray.append(annotation)
        }
        
        self.mapView.addAnnotations(annotationArray)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else {return}
            checkAndOpen(parentViewController: self, urlString: subtitle!)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        getData(parentView: self.view,
                parseSingleton: parseSingleton,
                with: {self.studentLocations = $0})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(parentView: self.view,
                parseSingleton: parseSingleton,
                with: {self.studentLocations = $0})
        
        mapView.delegate = self
        print(udacityModel.credentials)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        udacitySingleton.deleteSession()
        dismissSelf()
    }
}
