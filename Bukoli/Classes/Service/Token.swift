//
//  Token.swift
//  Pods
//
//  Created by Utku Yildirim on 02/11/2016.
//
//

import Foundation
import ObjectMapper

class Token: Mappable {
    var token: String!
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        token  <- map["token"]
    }
    
}
