//
//  Suggestion.swift
//  Pods
//
//  Created by Utku Yıldırım on 02/10/2016.
//
//

import Foundation
import ObjectMapper

class Suggestion: Mappable {
    var id: String!
    var name: String!
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
    }
    
}
