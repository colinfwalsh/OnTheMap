//
//  CWError.swift
//  OnTheMap
//
//  Created by Colin Walsh on 2/5/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation

enum CWError: Error {
    case userDataError
    case urlError
    case locationError
    case serverError
    case invalidCredentials
}

extension CWError: CustomStringConvertible {
    var description: String {
        switch self {
        case .userDataError:
            return "Could not get user data, check your network settings and try again"
        case .urlError:
            return "Cannot add the url.  Please add 'http://' or https://"
        case .locationError:
            return "Could not parse location entered.  Try another location or check your spelling."
        case .invalidCredentials:
            return "Your login credentials are incorrect.  Please check your username and password and try again."
        default:
            return "Cannot communicate with the server.  Try again soon"
        }
    }
    
    var title: String {
        switch self {
        case .userDataError:
            return "Cannot fetch user data"
        case .urlError:
            return "Invalid URL"
        case .locationError:
            return "Cannot get location"
        case .invalidCredentials:
            return "Invalid Credentials"
        default:
            return "Network Error"
        }
    }
}
