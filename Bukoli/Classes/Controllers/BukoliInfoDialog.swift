//
//  BukoliInfoDialog.swift
//  Pods
//
//  Created by Macintosh on 30.09.2016.
//
//

import UIKit

class BukoliInfoDialog: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    
    // MARK: - Actions
    
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.descriptionLabel.text = String(format: self.descriptionLabel.text!, Bukoli.sharedInstance.brandName2)
        self.step1Label.text = String(format: self.step1Label.text!, Bukoli.sharedInstance.brandName)
    }
    
}
