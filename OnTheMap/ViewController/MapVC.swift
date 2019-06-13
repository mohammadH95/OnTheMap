//
//  MapVC.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 11/09/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    var studentLocations: [StudentLocation] = []
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addPin: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStudentLocation()
    }
    
    @IBAction func Refresh(_ sender: UIBarButtonItem) {
        getStudentLocation()
    }
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        API.logout { (error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func getStudentLocation() {
        API.getStudentLocation { (locations, error) in
            self.studentLocations = locations
            self.updateAnnotations()
        }
    }
    
    func updateAnnotations(){
        var annotations = [MKPointAnnotation]()

        for student in studentLocations {
            let lat = CLLocationDegrees(student.latitude ?? 0)
            let long = CLLocationDegrees(student.longitude ?? 0)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pinID"
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
            let app = UIApplication.shared
            guard let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) else { return }
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}
