//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 09/10/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
