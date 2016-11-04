//
//  ViewController.swift
//  Bukoli
//
//  Created by Utku Yıldırım on 09/20/2016.
//  Copyright (c) 2016 Utku Yıldırım. All rights reserved.
//

import UIKit
import Bukoli

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            Bukoli.sharedInstance.brandName = "Marka"
            Bukoli.sharedInstance.brandName2 = "Marka'dan"
            Bukoli.sharedInstance.buttonTextColor = UIColor.white
            Bukoli.sharedInstance.buttonBackgroundColor = UIColor(hex: 0xF4AD17)
            Bukoli.sharedInstance.shouldAskPhoneNumber = false
        } else if indexPath.section == 1 {
            Bukoli.sharedInstance.brandName = "Example 1"
            Bukoli.sharedInstance.brandName2 = "Example 1'den"
            Bukoli.sharedInstance.buttonTextColor = UIColor.white
            Bukoli.sharedInstance.buttonBackgroundColor = UIColor(hex: 0xAF005F)
            Bukoli.sharedInstance.shouldAskPhoneNumber = true
        } else if indexPath.section == 2 {
            Bukoli.sharedInstance.brandName = "Example 2"
            Bukoli.sharedInstance.brandName2 = "Example 2'den"
            Bukoli.sharedInstance.buttonTextColor = UIColor.white
            Bukoli.sharedInstance.buttonBackgroundColor = UIColor(hex: 0xF68B1E)
            Bukoli.sharedInstance.shouldAskPhoneNumber = false
        }
        
        if (indexPath.row == 0){
            Bukoli.setUser("1", "5551234567", "sdk@bukoli.com")
            Bukoli.select(self, { (result: BukoliResult, point: BukoliPoint?, phoneNumber: String?) in
                switch(result) {
                case .success:
                    self.handleSuccess(point, phoneNumber)
                case .phoneNumberMissing:
                    self.handlePhoneNumberMissing(point, phoneNumber)
                case .pointNotSelected:
                    self.handlePointNotSelected(point, phoneNumber)
                }
            })
        }
        else if (indexPath.row == 1){
            Bukoli.info(self)
        }
        else if (indexPath.row == 2){
            let alert = UIAlertController(title: "Check Point Status", message: "Plase type point code", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "TDR-1234"
            })
            alert.addAction(UIAlertAction(title: "Check", style: .cancel, handler: { (action) in
                let pointCode = alert.textFields!.first!.text!
                if (pointCode.characters.isEmpty) {
                    let errorAlert = UIAlertController(title: "Error", message: "Plase type point code", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                        self.present(alert, animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                
                Bukoli.pointStatus(pointCode, { (result, point) in
                    var title = ""
                    var message = ""
                    switch(result) {
                    case .enabled:
                        title = "Enabled"
                        message = "\(point!.code!) - \(point!.name!) is enabled."
                    case .disabled:
                        title = "Disabled"
                        message = "\(point!.code!) - \(point!.name!) is disabled."
                    case .notFound:
                        title = "Point Not Found"
                        message = "Point not existed or removed."
                    }
                    
                    let responseAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    responseAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(responseAlert, animated: true, completion: nil)
                    
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleSuccess(_ point: BukoliPoint?, _ phoneNumber: String?) {
        let pointCode = point!.code
        let pointName = point!.name
        
        var message = String(format:"Point Code: %@\nPoint Name: %@", pointCode!, pointName!)
        if (phoneNumber != nil) {
            message += "\nPhone Number: " + phoneNumber!
        }
        
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func handlePhoneNumberMissing(_ point: BukoliPoint?, _ phoneNumber: String?) {
        let pointCode = point!.code
        let pointName = point!.name
        
        var message = "Point selected but phone number is missing."
        message += String(format:"\nPoint Code: %@\nPoint Name: %@", pointCode!, pointName!)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handlePointNotSelected(_ point: BukoliPoint?, _ phoneNumber: String?) {
        let alert = UIAlertController(title: "Error", message: "Point not selected.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension UIColor {
    convenience init(hex:Int) {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
