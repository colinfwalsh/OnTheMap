//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/23/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation

struct ParseAPI {
    
    
    
    var baseRequest: URLRequest {
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
    }
    
    func getStudentLocations(with completion: @escaping ([String: Any]) -> Void) {
        
        let request = baseRequest
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getSingleStudentLocation(with completion: @escaping ([String: Any]) -> Void) {
        let request = baseRequest
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func postStudentLocation(with completion: @escaping ([String : Any]) -> Void) {
        var request = baseRequest
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func makeBodyString(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float) {
        
    }
    
    func putStudentLocation(with completion: @escaping ([String : Any]) -> Void) {
        var request = baseRequest
        request.url = request.url?.appendingPathComponent("8ZExGR5uX8")
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}
