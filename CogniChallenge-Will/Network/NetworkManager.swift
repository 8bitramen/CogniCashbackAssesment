//
//  NetworkManager.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    public enum userCase {
        case login, register
    }
    
    typealias registerUserCallback = (Result<String>) -> Void
    
    func userLoginOrRegister(username: String, email: String, userCase: userCase, completion: @escaping registerUserCallback) {
        
        guard !username.isEmpty else {
            completion(.failure(CustomError.usernameInvalid))
            return
        }
        
        guard !email.isEmpty, email.contains("@") else {
            completion(.failure(CustomError.emailInvalid))
            return
        }
        
        switch userCase {
        case .login:
            
            guard let token = User.authorizedUser.authToken else {
                completion(.failure(CustomError.tokenInvalid))
                return
            }
            
            loginUser(username: username, email: email, token: token) { (tokenResult) in
                switch tokenResult {
                case.success(let token):
                    completion(.success(token))
                case.failure(let error):
                    completion(.failure(error))
                }
            }
            
        case .register:
            registerUser(username: username, email: email) { (userTokenResult) in
                switch userTokenResult {
                case.success(let token):
                    completion(.success(token))
                case.failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        
        //        if let token = authToken {
        //            loginUser(username: username, email: email, token: token) { [unowned self](result) in
        //                switch result {
        //                case.success(let token):
        //                    completion(.success(token))
        //                case.failure(let error):
        //                    print(error.localizedDescription)
        //                    self.registerUser(username: username, email: email, completion: { (result) in
        //                        switch result {
        //                        case.success(let token):
        //                            completion(.success(token))
        //                        case.failure(let error):
        //                            completion(.failure(error))
        //                        }
        //                    })
        //                }
        //            }
        //        } else {
        //            registerUser(username: username, email: email) { (result) in
        //                switch result {
        //                case.success(let token):
        //                    completion(.success(token))
        //                case.failure(let error):
        //                    completion(.failure(error))
        //                }
        //            }
        //        }
    }
    
    // MARK: - Dev note - ideally these resources would be computed properties in some api class
    
    private func registerUser(username: String, email: String, completion: @escaping registerUserCallback) {
        
        let baseURL = Endpoint.register.path
        
        let params = [Endpoint.ApiKeys.usernameKey: username, Endpoint.ApiKeys.emailKey: email]
        let networkRequest = NetworkRequest(url: URL(string: baseURL)!,
                                            params: params,
                                            httpMethod: .POST,
                                            headers: nil)
        
        let registerResource = Resource<Bool>(urlRequest: networkRequest.request)
        
        Webservice().load(resource: registerResource) { (_, response) in
            if let token = (response as? HTTPURLResponse)?.allHeaderFields[Endpoint.ApiKeys.tokenKey] as? String {
                print(token)
                User.authorizedUser.authToken = token
                completion(.success(token))
                return
            }
            
            completion(.failure(CustomError.failedToRegisterUser))
        }
    }
    
    
    
    private func loginUser(username: String, email: String, token: String, completion: @escaping (Result<String>) -> Void) {
        
        let baseURL = Endpoint.login.path
        let urlRequest = NetworkRequest(url: URL(string: baseURL)!,
                                        params: [Endpoint.ApiKeys.usernameKey: username, Endpoint.ApiKeys.emailKey: email],
                                        httpMethod: .POST,
                                        headers: nil)
        
        urlRequest.request.addValue(token, forHTTPHeaderField: Endpoint.ApiKeys.tokenKey)
        
        typealias emptyDictCallback = [String: Any]
        
        let registerResource = Resource<emptyDictCallback>(urlRequest: urlRequest.request) { (json) -> emptyDictCallback? in
            return json as? emptyDictCallback
        }
        
        Webservice().load(resource: registerResource) { (user, response) in
            if let token = (response as? HTTPURLResponse)?.allHeaderFields[Endpoint.ApiKeys.tokenKey] as? String {
                print(token)
                User.authorizedUser.authToken = token
                completion(.success(token))
                return
            }
            
            if user == nil {
                completion(.failure(CustomError.userLoginFailed))
            }
        }
    }
    
    typealias getVenuesCallback = (Result<VenueModel>) -> Void
    func getVenues(completion: @escaping getVenuesCallback) {
        
        guard let token = User.authorizedUser.authToken else {
            completion(.failure(.tokenInvalid))
            return
        }
        
        let baseURL = Endpoint.venues.path
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [URLQueryItem(name: Endpoint.ApiKeys.cityKey,
                                              value: Endpoint.ApiKeys.areaKey)]
        
        guard let url = components.url else { return }
        
        let networkRequest = NetworkRequest(url: url, params: nil, httpMethod: .GET, headers: nil)
        networkRequest.request.addValue(token, forHTTPHeaderField: Endpoint.ApiKeys.tokenKey)
        
        let venueResource = Resource<VenueModel>(urlRequest: networkRequest.request)
        
        Webservice().load(resource: venueResource) { (venues, response) in
            if let token = (response as? HTTPURLResponse)?.allHeaderFields[Endpoint.ApiKeys.tokenKey] as? String {
                User().authToken = token
            }
            
            guard let venues = venues else {
                completion(.failure(CustomError.parsingFailure("venues")))
                return
            }
            
            completion(.success(venues))
            
        }
    }
}
