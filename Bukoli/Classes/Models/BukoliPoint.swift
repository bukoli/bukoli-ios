//
//  BukoliPoint.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import Foundation
import ObjectMapper
import MapKit

public class BukoliPoint: NSObject, Mappable, MKAnnotation {
    public var id : Int!
    public var code : String!
    public var name : String!
    public var phone : String!
    public var location : Location!
    public var address : String!
    public var district : String!
    public var county : String!
    public var city : String!
    public var isLocker : Bool!
    public var distance : Double!
    public var largeImageUrl : String!
    public var smallImageUrl : String!
    public var workingHours : WorkingHours?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        id              <- map["id"]
        code            <- map["code"]
        name            <- map["name"]
        phone           <- map["phone"]
        location        <- map["location"]
        address         <- map["address"]
        district        <- map["district"]
        county          <- map["county"]
        city            <- map["city"]
        isLocker        <- map["is_locker"]
        distance        <- map["distance"]
        largeImageUrl   <- map["large_image_url"]
        smallImageUrl   <- map["small_image_url"]
        workingHours    <- map["working_hours"]
    }
    
    //MARK: - MKAnnotation
    
    public var title: String? {
        return name
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.location.latitude!, self.location.longitude!)
    }
    
}
