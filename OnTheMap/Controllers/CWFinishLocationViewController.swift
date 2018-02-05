//
//  CWFinishLocationViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 2/5/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit
import MapKit

class CWFinishLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var stagingModel: StudentStagingModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.title = (stagingModel.firstName ?? "") + " " + (stagingModel.lastName ?? "")
        annotation.subtitle = stagingModel.mapString
        
        guard let latitude = stagingModel.latitude else {return}
        guard let longitude = stagingModel.longitude else {return}
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        mapView.addAnnotation(annotation)
        //https://stackoverflow.com/questions/34061162/how-to-zoom-into-pin-in-mkmapview-swift
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
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
            print(subtitle)
        }
    }

}
