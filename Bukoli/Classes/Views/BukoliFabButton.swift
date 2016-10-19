//
//  BukoliFabButton.swift
//  Pods
//
//  Created by Utku Yıldırım on 03/10/2016.
//
//

import UIKit

class BukoliFabButton: BukoliRoundedButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = Bukoli.sharedInstance.buttonTextColor
        self.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor.darker()
    }

}
