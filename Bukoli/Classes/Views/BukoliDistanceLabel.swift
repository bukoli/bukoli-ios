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
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        var rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
                rect.size.width += 8
                rect.size.height += 8
                return rect
    }
    
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
        // super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        
    }
    
    override func prepareForInterfaceBuilder() {
        self.awakeFromNib()
    }
    
}
