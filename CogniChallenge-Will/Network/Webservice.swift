//
//  Webservice.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import Foundation

//MARK: - Dev note - ultra light-weight networking request handler. Flatmap handles nil options. 

final class Webservice {
    typealias webServiceCompletion<A> = (A?, URLResponse?) -> Void
    func load<A>(resource: Resource<A>, completion: @escaping webServiceCompletion<A>) {
        URLSession.shared.dataTask(with: resource.urlRequest){ (data, response, error) in
            DispatchQueue.main.async {
                let result = data.flatMap(resource.parseClosure)
                completion(result, response)
            }
            }.resume()
    }
}
