//
//  BukoliPointCell.swift
//  Pods
//
//  Created by Macintosh on 30.09.2016.
//
//

import UIKit
import AlamofireImage

class BukoliPointCell: UITableViewCell {
    
    @IBOutlet weak var pointImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var mapViewController: BukoliMapViewController!
    
    var bukoliPoint: BukoliPoint! {
        didSet {
            pointImageView.af_setImage(withURL: URL(string: bukoliPoint.smallImageUrl)!)
            nameLabel.text = bukoliPoint.name
            addressLabel.text = bukoliPoint.address
            workingHoursLabel.text = bukoliPoint.workingHours?.readable()
            distanceLabel.text = String(format: "%.0f m", arguments: [bukoliPoint.distance])
        }
    }
    
    // MARK: - Class Functions
    
    class func sizeForItem(_ scrollView: UIScrollView) -> CGSize {
        var size = scrollView.frame.size
        // Max iPhone 6+ width
        size.width = min(size.width, 414)
        size.width -= 48
        return size
    }
    
    // MARK: - Actions
    
    @IBAction func selectPoint(_ sender: AnyObject) {
        Bukoli.sharedInstance.bukoliPoint = bukoliPoint
        mapViewController.pointSelected()
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero;
    }
    
    override func prepareForReuse() {
        pointImageView.af_cancelImageRequest()
        pointImageView.image = nil
    }

}
