//
//  BukoliButton.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import UIKit

class BukoliButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        self.setTitleColor( Bukoli.sharedInstance.buttonTextColor , for: .normal)
        self.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor
        
        self.layer.borderWidth = 1
        self.layer.borderColor = Bukoli.sharedInstance.buttonBackgroundColor.darker().cgColor
    }
    
    override func prepareForInterfaceBuilder() {
        self.awakeFromNib()
    }
}
