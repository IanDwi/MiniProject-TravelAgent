//
//  RegisterViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/28/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPassTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(_ sender: UIButton){
        
        //Validation
        if self.usernameTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Username cannot be empty")
            self.usernameTextField.layer.borderColor = UIColor.red.cgColor
            return
        } else if self.passwordTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Password cannot be empty")
            self.passwordTextField.layer.borderColor = UIColor.red.cgColor
            return
        } else if self.passwordTextField.text != confirmPassTextField.text {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Confirm Password not matched!")
            self.confirmPassTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        //Do Register
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        if DBWrapper.sharedInstance.doRegister(username: username, password: password) == true {
            Utilities.sharedInstance.showAlert(obj: self, title: "SUCCES", message: "You are now registered!")
        } else {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Can't registered!")
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
