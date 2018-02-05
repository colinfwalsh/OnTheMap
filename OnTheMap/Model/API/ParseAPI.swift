//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/23/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation

struct ParseAPI: APIProtocol {
    
    var baseRequest: URLRequest {
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
    }
    
    func getStudentLocations(with completion: @escaping (StudentArray?, Error?) -> Void) {
        
        let request = baseRequest
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            let (studentArray, err) = self.getStudentLocationArray(with: data)
            completion(studentArray, err)
        }
        task.resume()
    }
    
    func getSingleStudentLocation(with completion: @escaping (StudentArray?, Error?) -> Void) {
        let request = baseRequest
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            
            let (studentArray, err) = self.getStudentLocationArray(with: data)
            completion(studentArray, err)
            
        }
        task.resume()
    }
    
    private func getStudentLocationArray(with data: Data?) -> (StudentArray?, Error?) {
        
        guard let data = data else {return (nil, NSError.init(domain: "Data Error", code: 00, userInfo: ["Error with data": "Error"]) as Error)}
        do {
            return (try JSONDecoder().decode(StudentArray.self, from: data), nil)
        } catch let decodeErr {
            return (nil, decodeErr)
        }
        
        
    }
    
    func postStudentLocation(studentInfo: StudentStagingModel, with completion: @escaping ([String : Any], Error?) -> Void) {
        var request = baseRequest
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeBodyString(uniqueKey: studentInfo.uniqueKey ?? "", firstName: studentInfo.firstName ?? "", lastName: studentInfo.lastName ?? "", mapString: studentInfo.mapString ?? "", mediaURL: studentInfo.mediaUrl ?? "", latitude: studentInfo.latitude ?? 0.0, longitude: studentInfo.longitude ?? 0.0).data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion([:], CWError.serverError)
                return
            }
            
            completion(self.parseJson(with: data), nil)
        }
        task.resume()
    }
    
    func putStudentLocation(with completion: @escaping ([String : Any]) -> Void) {
        var request = baseRequest
        request.url = request.url?.appendingPathComponent("8ZExGR5uX8")
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeBodyString(uniqueKey: "1234", firstName: "John", lastName: "Doe", mapString: "Mountain View, CA", mediaURL: "https://udacity.com", latitude: 37.386052, longitude: -122.083851).data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            completion(self.parseJson(with: data))
        }
        task.resume()
    }
    
    private func makeBodyString(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double) -> String {
        
        return "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
    }
}
