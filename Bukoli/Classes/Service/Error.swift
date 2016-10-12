//
//  Error.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import Foundation
import ObjectMapper

class Error: Mappable {
    var code: String!
    var error: String!
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        code    <- map["code"]
        error   <- map["error"]
    }
    
}
