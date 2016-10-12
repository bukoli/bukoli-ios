//
//  BukoliDetailDialog.swift
//  Pods
//
//  Created by Utku Yıldırım on 03/10/2016.
//
//

import UIKit
import AlamofireImage

class BukoliDetailDialog: UIViewController {
    
    @IBOutlet weak var pointImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    
    var bukoliMapViewController: BukoliMapViewController!
    var bukoliPoint: BukoliPoint!
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: AnyObject) {
        Bukoli.sharedInstance.bukoliPoint = bukoliPoint
        self.dismiss(animated: true) {
            self.bukoliMapViewController.definesPresentationContext = true
            self.bukoliMapViewController.pointSelected()
        }
    }
    
    @IBAction func close(_ sender: AnyObject) {
        Bukoli.sharedInstance.bukoliPoint = nil
        bukoliMapViewController.definesPresentationContext = true
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pointImageView.af_setImage(withURL: URL(string: bukoliPoint.largeImageUrl)!)
        nameLabel.text = bukoliPoint.name
        addressLabel.text = bukoliPoint.address
        workingHoursLabel.text = bukoliPoint.workingHours?.readable()
    }

}
