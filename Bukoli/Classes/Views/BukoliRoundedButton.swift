//
//  BukoliRoundedButton.swift
//  Pods
//
//  Created by Utku Yildirim on 19/10/2016.
//
//

import Foundation

class BukoliRoundedButton: UIButton {
    var backgroundLayer: CALayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        layer.cornerRadius = self.frame.size.width/2
    }
    
    override func prepareForInterfaceBuilder() {
        self.awakeFromNib()
    }
}
