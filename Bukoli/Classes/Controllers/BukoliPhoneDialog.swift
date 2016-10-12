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
    
    @IBAction func save(_ sender: AnyObject) {
        
        // Validate Phone Number
        var phoneNumber = String(phoneNumberLabel.text!.characters.filter {
            return String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil
        })
        
        if (phoneNumber.characters.count < 11) {
            // Error
            let alert = UIAlertController(title: "Hata", message: "Girdiğiniz telefon numarası hatalıdır.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Remove first 0
        phoneNumber.characters.removeFirst()
        
        Bukoli.sharedInstance.phoneNumber = phoneNumber
        
        self.dismiss(animated: true) {
            self.bukoliMapViewController.close(sender)
        }
    }
    
    @IBAction func close(_ sender: AnyObject) {
        bukoliMapViewController.definesPresentationContext = true
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // TODO: Reimplement Phone Formatting
        let length = textField.text!.characters.count
        
        // Remove Char
        if (range.length == 1) {
            if length > range.location {
                let newPosition = textField.endOfDocument
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
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
    
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            self.centerYConstraint.constant = -endFrame!.size.height / 2;
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            self.centerYConstraint.constant = 0;
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}
