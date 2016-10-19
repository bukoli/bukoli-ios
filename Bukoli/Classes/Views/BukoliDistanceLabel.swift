//
//  BukoliDistanceLabel.swift
//  Pods
//
//  Created by Utku Yildirim on 19/10/2016.
//
//

import Foundation
class BukoliDistanceLabel: UILabel {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        rect.size.width += 8
        rect.size.height += 8
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func prepareForInterfaceBuilder() {
        self.awakeFromNib()
    }
    
}
