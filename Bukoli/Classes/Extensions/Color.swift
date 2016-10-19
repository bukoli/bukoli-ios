//
//  Color.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import UIKit

extension UIColor {
    convenience init(hex:Int64) {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    func darker() -> UIColor {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha){
            return UIColor(red: max(red - 0.05, 0.0), green: max(green - 0.05, 0.0), blue: max(blue - 0.05, 0.0), alpha: alpha)
        }
        return UIColor()
    }
    
    func lighter() -> UIColor {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha){
            return UIColor(red: min(red + 0.05, 1.0), green: min(green + 0.05, 1.0), blue: min(blue + 0.05, 1.0), alpha: alpha)
        }
        return UIColor()
    }
}

extension UIColor {
    class func bukoliOrange() -> UIColor {
        return UIColor(hex: 0xF4AD17)
    }
}
