//
//  WorkingHour.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import Foundation
import ObjectMapper

public class WorkingHour: Mappable {
    public var isWorking: Int!
    public var startHour: String!
    public var endHour: String!
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        isWorking    <- map["is_working"]
        startHour    <- map["start_hour"]
        endHour      <- map["end_hour"]
    }
    
}
