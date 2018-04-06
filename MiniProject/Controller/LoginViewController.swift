//
//  LoginViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/28/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @IBAction func MasukButton(_ sender: UIButton) {
        
        if self.usernameTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Username cannot be empty")
            self.usernameTextField.layer.borderColor = UIColor.red.cgColor
            return
        } else if self.passwordTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Password cannot be empty")
            self.passwordTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        if DBWrapper.sharedInstance.doLogin(username: username, password: password) != nil {
            self.performSegue(withIdentifier: "HomeSegue", sender: self)        //pindah ke halaman homepage
        } else {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "User Not Found")
        }
        
    }
    @IBAction func RegisterButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "RegisterSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 8
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 60.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 60.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
