//
//  Error.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import Foundation
import ObjectMapper

public class Error: Mappable {
    var code: String!
    var error: String!
    
    init(error: NSError) {
        self.code = String(error.code)
        self.error = error.localizedDescription
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        code    <- map["code"]
        error   <- map["error"]
    }
    
}
