//
//  UdacityModel.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/22/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation

class UdacityModel {
    static let sharedInstance = UdacityModel()
    
    var credentials: UdacityCredentials!
}

struct UdacityCredentials: Codable {
    let session: SessionObject?
    let account: AccountObject?
    let status: Int?
    let error: String?
}

struct SessionObject: Codable {
    let expiration: String
    let id: String
}

struct AccountObject: Codable {
    let key: String
    let registered: Int
}

struct UdacityUserDetails: Codable {
    let user: UdacityUserObject
}

struct UdacityUserObject: Codable {
    let first_name: String?
    let last_name: String?
}
