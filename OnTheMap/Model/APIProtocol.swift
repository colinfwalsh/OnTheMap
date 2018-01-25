//
//  APIProtocol.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/24/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation

protocol APIProtocol {
    var baseRequest: URLRequest {get}
}

extension APIProtocol {
    func parseJson(with data: Data?) -> [String : Any] {
        guard let data = data else {return [:]}
        
        let jsonData: [String : Any]!
        do {
            jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            return jsonData
        } catch let jsonErr {
            print(jsonErr)
        }
        
        return [:]
    }
}
