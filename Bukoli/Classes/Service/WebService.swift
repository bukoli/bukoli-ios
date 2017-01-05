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
//    
    static var integrationToken: String?

    private static var _manager: Manager!
    static var manager: Manager {
        get {
            if _manager == nil {
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                configuration.timeoutIntervalForRequest = 10
                
                _manager = Alamofire.Manager(configuration: configuration)
            }
            return _manager
        }
    }
//
    class func Authorize(success:(() -> Void), failure: ((Error) -> Void)) -> Request {
        let headers: [String: String] = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": NSBundle.mainBundle().bundleIdentifier!,
            ]
        
        let url = baseUrl + "authorize"
        
        var parameters: [String: String] = [:]
        parameters["user_code"] = Bukoli.sharedInstance.userCode
        parameters["email"] = Bukoli.sharedInstance.email
        parameters["phone"] = Bukoli.sharedInstance.phone
        
        parameters["app_version"] = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        parameters["app_build"] = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String
        parameters["sdk_version"] = NSBundle(forClass: self).objectForInfoDictionaryKey ("CFBundleShortVersionString") as? String
        
        parameters["os_version"] = UIDevice.currentDevice().systemVersion
        parameters["brand"] = "Apple"
        parameters["model"] = UIDevice.currentDevice().modelName
        
        
        
        return manager.request(.POST, url, parameters: parameters, encoding: .URL, headers: headers)
            .validate()
            .responseJSON {
                response in
                if (response.result.isSuccess) {
                    // Success
                    print(response.result.value)
                    let data = response.result.value as! [String: AnyObject]
                    if let object = Mapper<Token>().map(data) {
                        WebService.integrationToken = object.token
                        success()
                        return
                    }
                    
                } else if response.result.isFailure {
//                    let error = response.result.error as! NSError
//                    handleError(error, response.data!, failure)
                }
        }
    }

    
    class func GET<T: Mappable>(uri: String, parameters: [String: AnyObject]?, success: ((T) -> Void), failure: ((Error) -> Void)) -> Request {
        let headers: [String: String] = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": NSBundle.mainBundle().bundleIdentifier!,
            "X-Integration-Token": WebService.integrationToken ?? "",
            ]
        
        let url = baseUrl + uri
        
        
        return manager.request(.GET, url, parameters: parameters, encoding: .URLEncodedInURL, headers: headers)
            .validate()
            .responseJSON {
                response in
                if (response.result.isSuccess) {
                    // Success
                    print(response.result.value)
                    let data = response.result.value as! [String: AnyObject]
                    if let object = Mapper<T>().map(data) {
                        success(object as T)
                        return
                    }
                } else if response.result.isFailure {
                    let error = response.result.error!
                    handleError(error, data: response.data!, failure: failure)
                }
        }
    }
    
    class func POST(uri: String, parameters: [String: AnyObject]?) -> Request {
        let headers: [String: String] = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": NSBundle.mainBundle().bundleIdentifier!,
            "X-Integration-Token": WebService.integrationToken ?? "",
            ]
        
        let url = baseUrl + uri
        
        return manager.request(.POST, url, parameters: parameters, encoding: .URLEncodedInURL, headers: headers)
    }

    class func GET<T: Mappable>(uri: String, parameters: [String: AnyObject]?, success: (([T]) -> Void), failure:((Error) -> Void)) -> Request {
        let headers: [String: String] = [
            "X-iOS-Key": Bukoli.sharedInstance.password,
            "X-iOS-Package": NSBundle.mainBundle().bundleIdentifier!,
            "X-Integration-Token": WebService.integrationToken ?? "",
            ]
        
        let url = baseUrl + uri
        
        return manager.request(.GET, url, parameters: parameters, encoding: .URL, headers: headers)
            .validate()
            .responseJSON {
                response in
                
                if (response.result.isSuccess) {
                    // Success
                    print(response.result.value)
                    let data = response.result.value as! [[String: AnyObject]]
                    if let object = Mapper<T>().mapArray(data) {
                        success(object as [T])
                        return
                    }
                    
                    
                } else if response.result.isFailure {
                    let error = response.result.error!
                    handleError(error, data: response.data!, failure: failure)
                }
        }
    }
    
    class func handleError(error: NSError, data: NSData, failure: ((Error) -> Void)) {
        // Request cancelled
        if error.code == -999 {
            return
        }
        
        // Failure
        let jsonString = String(data: data, encoding: NSUTF8StringEncoding)!
        if let object = Mapper<Error>().map(jsonString) {
            failure(object)
            return
        }
        
        // Connection Error
        failure(Error(error: error))
    }
}
