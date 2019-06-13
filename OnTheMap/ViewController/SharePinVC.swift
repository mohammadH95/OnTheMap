//
//  SharePinVC.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 11/09/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import UIKit
import MapKit

class SharePinVC: UIViewController {
    
    var student: StudentLocation!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finsh: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateAnnotations()
        updateMap()
    }
    
    @IBAction func finshAction(_ sender: UIButton) {
        let newStudent = PostStudent(uniqueKey: student.uniqueKey!, firstName: student.firstName!, lastName: student.lastName!, mapString: student.mapString!, mediaURL: student.mediaURL!, latitude: student.latitude!, longitude: student.longitude!)
        
        API.createStudentLocation(student: newStudent, completion: handlercreateStudent(success:error:))
    }
    
    func handlercreateStudent(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showError(message: error?.localizedDescription ?? "")
        }
    }
    
    func updateAnnotations(){
        var annotations = [MKPointAnnotation]()
        
        let lat = CLLocationDegrees(student.latitude ?? 0)
        let long = CLLocationDegrees(student.longitude ?? 0)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(student.firstName ?? "") \(student.lastName ?? "")"
        
        annotations.append(annotation)
        self.mapView.addAnnotations(annotations)
    }
    
    func updateMap(){
        let location = CLLocationCoordinate2D(latitude: student.latitude ?? 0, longitude: student.longitude ?? 0)
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

extension SharePinVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pinId"
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
