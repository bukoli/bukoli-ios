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
    
    private init() {}
    
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
    public var buttonTextColor = UIColor.whiteColor()
    
    public class func initialize(password: String) {
        Bukoli.sharedInstance.password = password
    }
    
    public class func setUser(userCode: String, phone: String?, email: String?) {
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
    
    public class func select(presenterViewController: UIViewController, completion:(result: BukoliResult, point: BukoliPoint?, phoneNumber: String?) -> Void) {
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
        
        presenterViewController.presentViewController(viewController!, animated: true, completion: nil)
    }
    
    public class func info(presenterViewController: UIViewController) {
        if (!isInitialized()) {
            assertionFailure("Bukoli SDK must be initialized.")
        }
        
        let storyboard = UIStoryboard(name:"Bukoli", bundle:Bukoli.bundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier("BukoliInfoDialog") as! BukoliInfoDialog
        
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.modalTransitionStyle = .CrossDissolve
        
        
        presenterViewController.presentViewController(viewController, animated: true, completion: nil)
    }
    
    public class func pointStatus(pointCode: String ,completion:(result: BukoliPointResult, point: BukoliPoint?) -> Void) {
        if (!isInitialized()) {
            assertionFailure("Bukoli SDK must be initialized.")
        }
        WebService.GET(String(format:"point/%@", pointCode), parameters: nil, success: { (point: BukoliPoint) in
            completion(result: point.state == 1 ? .enabled : .disabled, point: point)
        }) { (error: Error) in
            completion(result: .notFound, point: nil)
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
        
        var parameters : [String: AnyObject] = [:]
        if (phoneNumber != nil) {
            parameters["phone"] = phoneNumber
        }
        
        if (result != .pointNotSelected) {
            WebService.POST(String(format: "point/%d/send", point!.id), parameters: parameters)
        }
        
        Bukoli.sharedInstance.completion(result, point, phoneNumber)
    }
    
    class func bundle() -> NSBundle {
        let bundle = NSBundle(forClass: self)
        let bundleUrl = bundle.URLForResource("Bukoli", withExtension: "bundle")!
        return NSBundle(URL: bundleUrl)!
    }
}
