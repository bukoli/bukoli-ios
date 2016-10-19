//
//  BukoliPointDialogCell.swift
//  Pods
//
//  Created by Utku Yildirim on 19/10/2016.
//
//

import Foundation

class BukoliPointDialogCell: UICollectionViewCell {
    
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var pointImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var indexView: UIView!
    @IBOutlet weak var indexLabel: UILabel!
    
    var bukoliDetailDialog: BukoliDetailDialog!
    
    var bukoliPoint: BukoliPoint! {
        didSet {
            pointImageView.af_setImage(withURL: URL(string: bukoliPoint.largeImageUrl)!)
            indexLabel.text = "\(index+1)"
            nameLabel.text = bukoliPoint.name
            addressLabel.text = bukoliPoint.address
            workingHoursLabel.text = bukoliPoint.workingHours?.readable()
            distanceLabel.text = String(format: "%.0f m", arguments: [bukoliPoint.distance])
            
            indexView.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor.lighter()
            indexView.layer.cornerRadius = 11
            indexView.layer.masksToBounds = true
            
            indexLabel.textColor = Bukoli.sharedInstance.buttonTextColor
        }
    }
    var index: Int!
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: AnyObject) {
        Bukoli.sharedInstance.bukoliPoint = bukoliPoint
        bukoliDetailDialog.dismiss(animated: true) {
            self.bukoliDetailDialog.bukoliMapViewController.definesPresentationContext = true
            self.bukoliDetailDialog.bukoliMapViewController.pointSelected()
        }
    }
    
    @IBAction func close(_ sender: AnyObject) {
        Bukoli.sharedInstance.bukoliPoint = nil
        bukoliDetailDialog.bukoliMapViewController.definesPresentationContext = true
        bukoliDetailDialog.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero;
        
        self.closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.close(_:))))
    }
    
    override func prepareForReuse() {
        pointImageView.af_cancelImageRequest()
        pointImageView.image = nil
    }
    
}
