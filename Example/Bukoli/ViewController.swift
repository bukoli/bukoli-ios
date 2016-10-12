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
            Bukoli.sharedInstance.brandName = "Markafoni"
            Bukoli.sharedInstance.brandName2 = "Markafoni'den"
            Bukoli.sharedInstance.buttonTextColor = UIColor.white
            Bukoli.sharedInstance.buttonBackgroundColor = UIColor(hex: 0xAF005F)
            Bukoli.sharedInstance.shouldAskPhoneNumber = true
        } else if indexPath.section == 2 {
            Bukoli.sharedInstance.brandName = "Koçtaş"
            Bukoli.sharedInstance.brandName2 = "Koçtaş'tan"
            Bukoli.sharedInstance.buttonTextColor = UIColor.white
            Bukoli.sharedInstance.buttonBackgroundColor = UIColor(hex: 0xF68B1E)
            Bukoli.sharedInstance.shouldAskPhoneNumber = false
        }
        
        if (indexPath.row == 0){
            Bukoli.select(self, { (result: BukoliResult, point: BukoliPoint?, phoneNumber: String?) in
                switch(result) {
                case .success:
                    self.handleSuccess(point, phoneNumber)
                    break
                case .phoneNumberMissing:
                    self.handlePhoneNumberMissing(point, phoneNumber)
                    break
                case .pointNotSelected:
                    self.handlePointNotSelected(point, phoneNumber)
                    break
                }
            })
        }
        else if (indexPath.row == 1){
            Bukoli.info(self)
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
        let alert = UIAlertController(title: "Hata", message: "Point not selected.", preferredStyle: .alert)
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
