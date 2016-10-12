//
//  BukoliFabButton.swift
//  Pods
//
//  Created by Utku Yıldırım on 03/10/2016.
//
//

import UIKit

class BukoliFabButton: UIButton {

    var backgroundLayer: CALayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        
        self.tintColor = Bukoli.sharedInstance.buttonTextColor
        self.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor.darker()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.size.width/2
    }
    
    override func prepareForInterfaceBuilder() {
        self.awakeFromNib()
    }

}
