//
//  UdacityAccount.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 08/10/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: UdacityAccount
}

struct UdacityAccount: Codable {
    let username: String
    let password: String
}
