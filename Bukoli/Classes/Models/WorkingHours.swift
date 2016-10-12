//
//  WorkingHours.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import Foundation
import ObjectMapper

public class WorkingHours: Mappable {
    public var weekdays: WorkingHour!
    public var saturday: WorkingHour!
    public var sunday: WorkingHour!
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        weekdays    <- map["weekdays"]
        saturday    <- map["saturday"]
        sunday      <- map["sunday"]
    }
    
    public func readable() -> String {
        return String(format: "Hafta içi: %@ - %@\nCumartesi: %@  - %@\nPazar: %@ - %@",
                      weekdays.startHour, weekdays.endHour,
                      saturday.startHour, saturday.endHour,
                      sunday.startHour, sunday.endHour)
    }
    
}
