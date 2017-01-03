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
    @IBOutlet weak var saveButton: UIButton!
    
    var bukoliDetailDialog: BukoliDetailDialog!
    
    var bukoliPoint: BukoliPoint! {
        didSet {
            pointImageView.af_setImageWithURL(NSURL(string: bukoliPoint.largeImageUrl)!)
           // pointImageView.af_setImage(withURL: URL(string: bukoliPoint.largeImageUrl)!)
            indexLabel.text = "\(index+1)"
            nameLabel.text = bukoliPoint.name
            addressLabel.text = bukoliPoint.address
            workingHoursLabel.text = bukoliPoint.workingHours?.readable()
            distanceLabel.text = String(format: "%.0f m", arguments: [bukoliPoint.distance])
            
            indexView.layer.cornerRadius = 11
            indexView.layer.masksToBounds = true
            
            if bukoliPoint.isLocker! {
                indexLabel.textColor = UIColor.whiteColor()
                indexView.backgroundColor = UIColor(hex: 0xFF31AADE).lighter()
                
                saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                saveButton.backgroundColor = UIColor(hex: 0xFF31AADE)
                saveButton.layer.borderColor = UIColor(hex: 0xFF31AADE).darker().CGColor
            }
            else {
                indexLabel.textColor = Bukoli.sharedInstance.buttonTextColor
                indexView.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor.lighter()
                
                saveButton.setTitleColor(Bukoli.sharedInstance.buttonTextColor, forState: .Normal)
                saveButton.backgroundColor = Bukoli.sharedInstance.buttonBackgroundColor
                saveButton.layer.borderColor = Bukoli.sharedInstance.buttonBackgroundColor.darker().CGColor
            }
        }
    }
    var index: Int!
    
    // MARK: - Actions
    
    @IBAction func save(sender: AnyObject) {
        Bukoli.sharedInstance.bukoliPoint = bukoliPoint
        bukoliDetailDialog.dismissViewControllerAnimated(true) {
            self.bukoliDetailDialog.bukoliMapViewController.definesPresentationContext = true
            self.bukoliDetailDialog.bukoliMapViewController.pointSelected()
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        Bukoli.sharedInstance.bukoliPoint = nil
        bukoliDetailDialog.bukoliMapViewController.definesPresentationContext = true
        bukoliDetailDialog.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero;
        
        self.closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.close(_:))))
    }
    
    override func prepareForReuse() {
        pointImageView.af_cancelImageRequest()
        pointImageView.image = nil
    }
    
}
