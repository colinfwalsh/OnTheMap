//
//  CWFinishLocationViewController.swift
//  OnTheMap
//
//  Created by Colin Walsh on 2/5/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit
import MapKit

class CWFinishLocationViewController: UIViewController, HelperProtocol, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var stagingModel: StudentStagingModel!
    let parseAPI = ParseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.title = (stagingModel.firstName ?? "") + " " + (stagingModel.lastName ?? "")
        annotation.subtitle = stagingModel.mapString
        
        mapView.delegate = self
        
        guard let latitude = stagingModel.latitude else {return}
        guard let longitude = stagingModel.longitude else {return}
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        mapView.addAnnotation(annotation)
        //https://stackoverflow.com/questions/34061162/how-to-zoom-into-pin-in-mkmapview-swift
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        self.parseAPI.postStudentLocation(studentInfo: stagingModel,
                                          with: {model, error in
                                            DispatchQueue.main.async {
                                                if error != nil {
                                                    let error = error as! CWError
                                                    
                                                    self.presentAlertWith(parentViewController: self, title: error.title, message: error.description)
                                                    return
                                                } else {
                                                    self.navigationController?.popToRootViewController(animated: true)
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                            }
        })
       
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
}
