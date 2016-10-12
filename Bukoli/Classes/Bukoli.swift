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

public class Bukoli
{
    public static let sharedInstance = Bukoli()
    
    fileprivate init() {}
    
    var completion: ((BukoliResult, BukoliPoint?, String?) -> Void)!
    var password: String!
    var bukoliPoint: BukoliPoint?
    var phoneNumber: String?
    
    public var shouldAskPhoneNumber = false
    public var brandName = "Marka"
    public var brandName2 = "Marka'dan"
    public var buttonBackgroundColor = UIColor.bukoliOrange()
    public var buttonTextColor = UIColor.white
    
    public class func initialize(_ password: String) {
        Bukoli.sharedInstance.password = password
    }
    
    public class func select(_ presenterViewController: UIViewController, _ completion: @escaping (_ result: BukoliResult, _ point: BukoliPoint?, _ phoneNumber: String?) -> Void) {
        Bukoli.sharedInstance.bukoliPoint = nil
        Bukoli.sharedInstance.phoneNumber = nil
        Bukoli.sharedInstance.completion = completion
        
        let storyboard = UIStoryboard(name:"Bukoli", bundle:Bukoli.bundle())
        let viewController = storyboard.instantiateInitialViewController()
        
        presenterViewController.present(viewController!, animated: true, completion: nil)
    }
    
    public class func info(_ presenterViewController: UIViewController) {
        let storyboard = UIStoryboard(name:"Bukoli", bundle:Bukoli.bundle())
        let viewController = storyboard.instantiateViewController(withIdentifier: "BukoliInfoDialog") as! BukoliInfoDialog
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
        presenterViewController.present(viewController, animated: true, completion: nil)
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
        
        Bukoli.sharedInstance.completion(result, point, phoneNumber)
    }
    
    class func bundle() -> Bundle {
        let bundle = Bundle(for: self)
        let bundleUrl = bundle.url(forResource: "Bukoli", withExtension: "bundle")!
        return Bundle(url: bundleUrl)!
    }
}
