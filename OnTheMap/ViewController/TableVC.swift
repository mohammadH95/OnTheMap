//
//  TableVC.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 11/09/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    var studentLocations: [StudentLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        getStudentLocation()
    }
    @IBAction func refresh(_ sender: Any) {
        getStudentLocation()
    }
    
    @IBAction func logout(_ sender: Any) {
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
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId")!
        let student = studentLocations[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName ?? "") \(student.lastName ?? "")"
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocations[indexPath.row]
        guard let toOpen = student.mediaURL , let url = URL(string: toOpen) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
