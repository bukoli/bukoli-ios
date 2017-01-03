//
//  Information.swift
//  Pods
//
//  Created by Utku Yildirim on 19/10/2016.
//
//

import Foundation
import ObjectMapper

class Information: Mappable {
    var information: String!
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        information    <- map["information"]
    }
    
}
