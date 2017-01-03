//
//  BukoliResponse.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import Foundation
import ObjectMapper

class BukoliResponse<T: Mappable>: Mappable {
    var data: [T]!
    var address: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        data    <- map["data"]
        address <- map["address"]
    }
    
}
