//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/23/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation

struct UdacityAPI: APIProtocol {
    
    static let sharedInstance = UdacityAPI()
    
    var baseRequest: URLRequest {
        let url = URL(string: "https://www.udacity.com/api/session")
        let request = URLRequest(url: url!)
        return request
    }
    
    func postLoginWith(emailText: String, passwordText: String, with completion: @escaping ([String : Any], Error?) -> Void) {
        var request = baseRequest
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".data(using: .utf8, allowLossyConversion: false)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion([:], error!)
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            completion(self.parseJson(with: newData), nil)
            
        }
        task.resume()
    }
    
    func deleteSession() {
        var request = baseRequest
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            if let newData = newData {
                print(String(data: newData, encoding: .utf8)!)
            }
        }
        task.resume()
    }
}
