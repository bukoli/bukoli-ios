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
    
    private static var _manager: SessionManager!
    static var manager: SessionManager {
        get {
            if _manager == nil {
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 10
                
                _manager = SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: nil)
            }
            return _manager
        }
    }
    
    @discardableResult
    class func GET<T: Mappable>(uri: String, parameters: [String: Any]?, success: @escaping ((_ response: T) -> Void), failure: @escaping((_ error: Error) -> Void)) -> Request {
        let headers: HTTPHeaders = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": Bundle.main.bundleIdentifier!,
            ]
        
        let url = baseUrl + uri
        
        return manager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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
                    let error = response.result.error as! NSError
                    handleError(error, response.data!, failure)
                }
        }
    }
    
    @discardableResult
    class func GET<T: Mappable>(uri: String, parameters: [String: Any]?, success: @escaping ((_ response: [T]) -> Void), failure: @escaping((_ error: Error) -> Void)) -> Request {
        let headers: HTTPHeaders = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": Bundle.main.bundleIdentifier!,
            ]
        
        let url = baseUrl + uri
        
        return manager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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
                    let error = response.result.error as! NSError
                    handleError(error, response.data!, failure)
                }
        }
    }
    
    class func handleError(_ error: NSError, _ data: Data, _ failure: @escaping((_ error: Error) -> Void)) {
        // Request cancelled
        if error.code == -999 {
            return
        }
        
        // Failure
        let jsonString = String(data: data, encoding: String.Encoding.utf8)!
        if let object = Mapper<Error>().map(JSONString: jsonString) {
            failure(object)
            return
        }
        
        // Connection Error
        failure(Error(error))
    }
}
