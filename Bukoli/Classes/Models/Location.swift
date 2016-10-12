//
//  Location.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import Foundation
import ObjectMapper

public class Location: Mappable {
    public var latitude: Double!
    public var longitude: Double!
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
    }
    
}
