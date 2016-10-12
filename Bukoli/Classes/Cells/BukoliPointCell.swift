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
    
    var mapViewController: BukoliMapViewController!
    
    var bukoliPoint: BukoliPoint! {
        didSet {
            pointImageView.af_setImage(withURL: URL(string: bukoliPoint.largeImageUrl)!)
            nameLabel.text = bukoliPoint.name
            addressLabel.text = bukoliPoint.address
            workingHoursLabel.text = bukoliPoint.workingHours?.readable()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func selectPoint(_ sender: AnyObject) {
        Bukoli.sharedInstance.bukoliPoint = bukoliPoint
        mapViewController.pointSelected()
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        pointImageView.af_cancelImageRequest()
        pointImageView.image = nil
    }

}
