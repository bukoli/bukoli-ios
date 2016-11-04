//
//  Bukoli.swift
//  Pods
//
//  Created by Utku Yıldırım on 20.09.2016.
//
//

import Foundation
import UIKit


public enum BukoliResult {
    case success, pointNotSelected, phoneNumberMissing
}

public enum BukoliPointResult {
    case enabled, disabled, notFound
}

public class Bukoli
{
    public static let sharedInstance = Bukoli()
    
    fileprivate init() {}
    
    var completion: ((BukoliResult, BukoliPoint?, String?) -> Void)!
    var password: String!
    var bukoliPoint: BukoliPoint?
    var phoneNumber: String?
    
    var userCode: String?
    var phone: String?
    var email: String?
    
    public var shouldAskPhoneNumber = false
    public var brandName = "Marka"
    public var brandName2 = "Marka'dan"
    public var buttonBackgroundColor = UIColor.bukoliOrange()
    public var buttonTextColor = UIColor.white
    
    public class func initialize(_ password: String) {
        Bukoli.sharedInstance.password = password
    }
    
    public class func setUser(_ userCode: String, _ phone: String?, _ email: String?) {
        Bukoli.sharedInstance.userCode = userCode
        Bukoli.sharedInstance.phone = phone
        Bukoli.sharedInstance.email = email
    }
    
    class func isInitialized() -> Bool
    {
        return (Bukoli.sharedInstance.password != nil) && !Bukoli.sharedInstance.password.isEmpty
    }
    
    class func isUserDataSet() -> Bool {
        return (Bukoli.sharedInstance.userCode != nil) && !Bukoli.sharedInstance.userCode!.isEmpty
    }
    
    public class func select(_ presenterViewController: UIViewController, _ completion: @escaping (_ result: BukoliResult, _ point: BukoliPoint?, _ phoneNumber: String?) -> Void) {
        if (!isInitialized()) {
            assertionFailure("Bukoli SDK must be initialized.")
        }
        if (!isUserDataSet()) {
            assertionFailure("User Data must be set.")
        }
        
        WebService.integrationToken = nil
        Bukoli.sharedInstance.bukoliPoint = nil
        Bukoli.sharedInstance.phoneNumber = nil
        Bukoli.sharedInstance.completion = completion
        
        let storyboard = UIStoryboard(name:"Bukoli", bundle:Bukoli.bundle())
        let viewController = storyboard.instantiateInitialViewController()
        
        presenterViewController.present(viewController!, animated: true, completion: nil)
    }
    
    public class func info(_ presenterViewController: UIViewController) {
        if (!isInitialized()) {
            assertionFailure("Bukoli SDK must be initialized.")
        }
        
        let storyboard = UIStoryboard(name:"Bukoli", bundle:Bukoli.bundle())
        let viewController = storyboard.instantiateViewController(withIdentifier: "BukoliInfoDialog") as! BukoliInfoDialog
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
        presenterViewController.present(viewController, animated: true, completion: nil)
    }
    
    public class func pointStatus(_ pointCode: String ,_ completion: @escaping (_ result: BukoliPointResult, _ point: BukoliPoint?) -> Void) {
        if (!isInitialized()) {
            assertionFailure("Bukoli SDK must be initialized.")
        }
        WebService.GET(uri: String(format:"point/%@", pointCode), parameters: nil, success: { (point: BukoliPoint) in
            completion(point.state == 1 ? .enabled : .disabled, point)
        }) { (error: Error) in
            completion(.notFound, nil)
        }
    }
    
    class func complete() {
        let point = Bukoli.sharedInstance.bukoliPoint
        let phoneNumber = Bukoli.sharedInstance.phoneNumber
        let shouldAskPhoneNumber = Bukoli.sharedInstance.shouldAskPhoneNumber
        
        var result: BukoliResult = .success
        if (point == nil) {
            result = .pointNotSelected
        }
        else if (shouldAskPhoneNumber && phoneNumber == nil) {
            result = .phoneNumberMissing
        }
        
        var parameters : [String: Any] = [:]
        if (phoneNumber != nil) {
            parameters["phone"] = phoneNumber
        }
        
        if (result != .pointNotSelected) {
            WebService.POST(uri: String(format: "point/%d/send", point!.id), parameters: parameters)
        }
        
        Bukoli.sharedInstance.completion(result, point, phoneNumber)
    }
    
    class func bundle() -> Bundle {
        let bundle = Bundle(for: self)
        let bundleUrl = bundle.url(forResource: "Bukoli", withExtension: "bundle")!
        return Bundle(url: bundleUrl)!
    }
}
