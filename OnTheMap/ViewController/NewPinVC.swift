//
//  NewPinVC.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 11/09/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import UIKit
import MapKit

class NewPinVC: UIViewController {
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var websitText: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func FindAction(_ sender: UIButton) {
        activityIndicator.startAnimating()
        
        let location = MKLocalSearch.Request()
        location.naturalLanguageQuery = locationText.text
        let request = MKLocalSearch(request: location)
        
        request.start { (response, error) in
            guard let response = response else {
                self.showError(message: error?.localizedDescription ?? "")
                self.activityIndicator.stopAnimating()
                return
            }
            let lat = response.boundingRegion.center.latitude as Double
            let long = response.boundingRegion.center.longitude as Double
            self.getStudent(lat: lat, long: long)
        }
    }
    
    func getStudent(lat: Double, long: Double) {
        API.getStudentInfo { (student, error) in
            guard let student = student else {
                self.showError(message: error?.localizedDescription ?? "")
                self.activityIndicator.stopAnimating()
                return
            }
            let info = StudentLocation(createdAt: "", firstName: student.firstName, lastName: student.lastName, latitude: lat, longitude: long, mapString: self.locationText.text, mediaURL: self.websitText.text, objectId: "", uniqueKey: API.User.userId, updatedAt: "")
            self.passData(student: info)
        }
    }
    
    func passData(student: StudentLocation) {
        activityIndicator.stopAnimating()
        
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SharePinVC") as! SharePinVC
        mapVC.student = student
        
        self.navigationController?.pushViewController(mapVC, animated: true)
        
    }
}

extension NewPinVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationText.resignFirstResponder()
        websitText.resignFirstResponder()
        return true
    }
}
