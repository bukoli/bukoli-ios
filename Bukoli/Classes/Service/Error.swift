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
    
    init(_ error: NSError) {
        self.code = String(error.code)
        self.error = error.localizedDescription
    }
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        code    <- map["code"]
        error   <- map["error"]
    }
    
}
