//
//  Result + Error.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import Foundation
import UIKit

enum Result<A> {
    case success(A)
    case failure(CustomError)
}

enum CustomError: Error {
    case parsingFailure(String)
    case usernameInvalid
    case emailInvalid
    case failedToRegisterUser
    case customError(String)
    case tokenInvalid
    case userLoginFailed
}

extension CustomError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .parsingFailure(let object):
            return "failed to create \(object) from network"
        case .tokenInvalid:
            return "Token is invalid"
        case .usernameInvalid:
            return "username is invalid"
        case .emailInvalid:
            return "username is invalid"
        case .failedToRegisterUser:
            return "failed to register user"
        case .userLoginFailed:
            return "failed to login user - username or password incorrect"
        case .customError(let description):
            return description
        }
    }
}

extension UIViewController {
    func presentError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

