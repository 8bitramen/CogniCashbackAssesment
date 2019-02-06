//
//  VenueModel.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import Foundation
import MapKit

struct VenueModel: Codable {
    let venues: [Venue]
}


class Venue: NSObject, Codable, MKAnnotation {
    let id: Int
    let uuid: String
    let name: String
    let city: String
    let cashback: Double
    let lat: Double
    let long: Double
    let user_id: Int?
    let created_at: String
    let updated_at: String
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }
    
    var title: String? {
        get {
            return "\(cashback)%"
        }
    }
    
    var subtitle: String? {
        get {
            var text = "\(name), \(city)"
            
            if let user = user_id {
                text += ", User: \(user)"
            }
            
            return text
        }
    }
}
