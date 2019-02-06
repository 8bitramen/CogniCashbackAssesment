//
//  CogniNetworkResource.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import Foundation

//MARK: - Dev note - Builds generic resources that would be reusable for a myriad of api's. This should ideally be more robust, but this allows you to construct api calls for three different endpoints using one easily managed object.

struct Resource<A> {
    let urlRequest: URLRequest
    let parseClosure: (Data) -> A?
}

extension Resource {
    init(urlRequest: URLRequest, parseJSONClosure: @escaping (Any) -> A?) {
        self.urlRequest = urlRequest
        self.parseClosure = {
            let json = try? JSONSerialization.jsonObject(with: $0, options: [])
            return json.flatMap(parseJSONClosure)
        }
    }
}

extension Resource where A: Decodable {
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
        self.parseClosure = { try? JSONDecoder().decode(A.self, from: $0) }
    }
}

class NetworkRequest {
    var request: URLRequest
    
    init(url: URL, params: [String: Any]?, httpMethod: HTTPMethod, headers: [String: String]?) {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue(Endpoint.RequestConstants.applicationJSON, forHTTPHeaderField: Endpoint.RequestConstants.contentTypeKey)
        
        if let params = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        self.request = request
    }
}
