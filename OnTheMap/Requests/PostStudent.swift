//
//  PostStudent.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 10/10/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import Foundation

struct PostStudent: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
}
