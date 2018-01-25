//
//  ParseModel.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/22/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation


struct ParseModel {
    static let sharedInstance = ParseModel()
    
    var studentArray: StudentArray = StudentArray(results: [])
}

struct StudentArray: Codable {
    var results: [StudentInformation]
}

struct StudentInformation: Codable {
    var createdAt: String
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String
    var uniqueKey: String?
    var updatedAt: String
}
