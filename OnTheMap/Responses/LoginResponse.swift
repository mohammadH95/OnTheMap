//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 08/10/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
