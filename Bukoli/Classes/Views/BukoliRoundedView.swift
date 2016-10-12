//
//  BukoliRoundedView.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import UIKit

class BukoliRoundedView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        self.awakeFromNib()
    }

}
