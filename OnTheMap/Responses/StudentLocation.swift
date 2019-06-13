//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 08/10/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}
