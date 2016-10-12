//
//  WebService.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import Foundation
import Alamofire
import ObjectMapper

private var baseUrl = "http://bukoli.mobillium.com/integration/"

class WebService {
    class func GET<T: Mappable>(uri: String, parameters: [String: Any]?, success: @escaping ((_ response: T) -> Void), failure: @escaping((_ error: Error) -> Void)) -> Request {
        let headers: HTTPHeaders = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": Bundle.main.bundleIdentifier!,
            ]
        
        let url = baseUrl + uri
        
        return Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON {
                response in
                
                if (response.result.isSuccess) {
                    // Success
                    let data = response.result.value as! [String: Any]
                    if let object = Mapper<T>().map(JSON: data) {
                        success(object as T)
                        return
                    }
                } else if response.result.isFailure {
                    // Failure
                    let data = String(data: response.data!, encoding: String.Encoding.utf8)!
                    if let object = Mapper<Error>().map(JSONString: data) {
                        failure(object)
                        return
                    }
                }
        }
    }
    
    class func GET<T: Mappable>(uri: String, parameters: [String: Any]?, success: @escaping ((_ response: [T]) -> Void), failure: @escaping((_ error: Error) -> Void)) -> Request {
        let headers: HTTPHeaders = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": Bundle.main.bundleIdentifier!,
            ]
        
        let url = baseUrl + uri
        
        return Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON {
                response in
            
                if (response.result.isSuccess) {
                    // Success
                    let data = response.result.value as! [[String: Any]]
                    if let object = Mapper<T>().mapArray(JSONArray: data) {
                        success(object as [T])
                        return
                    }
                    
                    
                } else if response.result.isFailure {
                    // Failure
                    let data = String(data: response.data!, encoding: String.Encoding.utf8)!
                    if let object = Mapper<Error>().map(JSONString: data) {
                        failure(object)
                        return
                    }
                }
        }
    }
}
