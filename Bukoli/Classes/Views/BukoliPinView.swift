//
//  BukoliAnnotationView.swift
//  Pods
//
//  Created by Utku Yıldırım on 01/10/2016.
//
//

import UIKit
import MapKit

class BukoliPinView: UIView {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        self.imageView.tintColor = Bukoli.sharedInstance.buttonBackgroundColor
        self.centerView.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor.lighter()
        self.centerView.layer.cornerRadius = 11
        self.centerView.layer.masksToBounds = true
        self.centerView.layer.borderWidth = 1
        self.centerView.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
