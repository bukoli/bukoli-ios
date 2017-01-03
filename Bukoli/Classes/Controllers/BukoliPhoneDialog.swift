//
//  BukoliPhoneDialog.swift
//  Pods
//
//  Created by Utku Yıldırım on 03/10/2016.
//
//

import UIKit

class BukoliPhoneDialog: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    var bukoliMapViewController: BukoliMapViewController!
    
    // MARK: - Actions
    
    @IBAction func save(sender: AnyObject) {
        
        // Validate Phone Number
        var phoneNumber = String(phoneNumberLabel.text!.characters.filter {
            return String($0).rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "0123456789")) != nil
            })
        
        if (phoneNumber.characters.count < 11) {
            // Error
            let alert = UIAlertController(title: "Hata", message: "Girdiğiniz telefon numarası hatalıdır.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // Remove first 0
        phoneNumber = String(phoneNumber.characters.dropFirst())
        
        Bukoli.sharedInstance.phoneNumber = phoneNumber
        
        self.dismissViewControllerAnimated(true, completion: {
            self.bukoliMapViewController.close(sender)
        })
    }
    
    @IBAction func close(sender: AnyObject) {
        bukoliMapViewController.definesPresentationContext = true
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // TODO: Reimplement Phone Formatting
        let length = textField.text!.characters.count
        
        // Remove Char
        if (range.length == 1) {
            if length > range.location {
                let newPosition = textField.endOfDocument
                textField.selectedTextRange = textField.textRangeFromPosition(newPosition, toPosition: newPosition)
            }
            return true
        }
        
        if (length >= 17) {
            return false
        }
        
        if range.location >= 17 {
            return false
        } else if range.location == 0 {
            textField.insertText("0 (")
            if (string == "0") {
                return false
            }
        } else if range.location == 1 {
            textField.insertText(" (")
        } else if range.location == 2 {
            textField.insertText("(")
        } else if range.location == 6 {
            textField.insertText(") ")
        } else if range.location == 7 {
            textField.insertText(" ")
        } else if range.location == 11 {
            textField.insertText(" ")
        } else if range.location == 14 {
            textField.insertText(" ")
        }
        return true
    }
    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedIntegerValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            self.centerYConstraint.constant = -endFrame!.size.height / 2;
            UIView.animateWithDuration(duration, delay: NSTimeInterval(0), options: animationCurve, animations: {self.view.layoutIfNeeded()}, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedIntegerValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            self.centerYConstraint.constant = 0;
            UIView.animateWithDuration(duration, delay: NSTimeInterval(0), options: animationCurve,animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear( animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
}
