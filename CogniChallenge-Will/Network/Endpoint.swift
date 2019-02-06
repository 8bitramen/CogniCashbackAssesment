//
//  Endpoint.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import Foundation

protocol CogniEndpointProtocol {
    var path: String { get }
}

enum Endpoint: CogniEndpointProtocol {
    
    struct EndpointConstants {
        static let host = "https://cashback-explorer-api.herokuapp.com"
        static let users = "/users"
        static let login = "/login"
        static let venues = "/venues"
    }
    
    struct ApiKeys {
        static let usernameKey = "name"
        static let emailKey = "email"
        static let cityKey = "city"
        static let areaKey = "New York"
        
        static let tokenKey = "Token"
    }
    
    struct RequestConstants {
        static let contentTypeKey = "Content-Type"
        static let applicationJSON = "application/json"
    }
    
    case register, login, venues
    
    var path: String {
        var baseURL = EndpointConstants.host
        switch self {
        case .register:
            baseURL += EndpointConstants.users
        case .login:
            baseURL += EndpointConstants.login
        case .venues:
            baseURL += EndpointConstants.venues
        }
        return baseURL
    }
}

enum HTTPMethod: String {
    case POST, GET
}
