//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/23/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation

struct UdacityAPI {
    
    static let sharedInstance = UdacityAPI()
    
    let url = URL(string: "https://www.udacity.com/api/session")
    
    func postLoginWith(emailText: String, passwordText: String, with completion: @escaping ([String : Any]) -> Void) {
        var request = URLRequest(url: self.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".data(using: .utf8, allowLossyConversion: false)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            //print(String(data: data!, encoding: .utf8)!)
            
            guard let data = newData else {print("Something is wrong with the data"); return}
            let jsonResult : [String : Any]
            do {
                jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                completion(jsonResult)
            } catch let jsonErr {
                print("There is an error! \(jsonErr)")
                completion([:])
            }
            
            
        }
        task.resume()
    }
    
    func deleteSession() {
        var request = URLRequest(url: self.url!)
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
