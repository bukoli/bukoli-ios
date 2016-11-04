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
    
    static var integrationToken: String?
    
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
    class func Authorize(success: @escaping (() -> Void), failure: @escaping((_ error: Error) -> Void)) -> Request {
        let headers: HTTPHeaders = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": Bundle.main.bundleIdentifier!,
            ]
        
        let url = baseUrl + "authorize"
        
        var parameters: [String: String] = [:]
        parameters["user_code"] = Bukoli.sharedInstance.userCode
        parameters["email"] = Bukoli.sharedInstance.email
        parameters["phone"] = Bukoli.sharedInstance.phone
        
        parameters["app_version"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        parameters["app_build"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        parameters["sdk_version"] = Bundle(for: self).object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        parameters["os_version"] = UIDevice.current.systemVersion
        parameters["brand"] = "Apple"
        parameters["model"] = UIDevice.current.modelName
        
        return manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON {
                response in
                if (response.result.isSuccess) {
                    // Success
                    let data = response.result.value as! [String: Any]
                    if let object = Mapper<Token>().map(JSON: data) {
                        WebService.integrationToken = object.token
                        success()
                        return
                    }
                    
                } else if response.result.isFailure {
                    let error = response.result.error as! NSError
                    handleError(error, response.data!, failure)
                }
        }
    }

    
    @discardableResult
    class func GET<T: Mappable>(uri: String, parameters: [String: Any]?, success: @escaping ((_ response: T) -> Void), failure: @escaping((_ error: Error) -> Void)) -> Request {
        let headers: HTTPHeaders = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": Bundle.main.bundleIdentifier!,
            "X-Integration-Token": WebService.integrationToken ?? "",
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
    class func POST(uri: String, parameters: [String: Any]?) -> Request {
        let headers: HTTPHeaders = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": Bundle.main.bundleIdentifier!,
            "X-Integration-Token": WebService.integrationToken ?? "",
            ]
        
        let url = baseUrl + uri
        
        return manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
    }
    
    @discardableResult
    class func GET<T: Mappable>(uri: String, parameters: [String: Any]?, success: @escaping ((_ response: [T]) -> Void), failure: @escaping((_ error: Error) -> Void)) -> Request {
        let headers: HTTPHeaders = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": Bundle.main.bundleIdentifier!,
            "X-Integration-Token": WebService.integrationToken ?? "",
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
