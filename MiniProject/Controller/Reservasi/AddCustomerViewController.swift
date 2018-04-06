//
//  AddCustomerViewController.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class AddCustomerViewController: UIViewController {
    
    @IBOutlet var namaTextField: UITextField!
    @IBOutlet var alamatTextField: UITextField!
    @IBOutlet var teleponTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonDidPushed(_ sender: UIButton){
        // validation
        if self.namaTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "kolom nama tidak boleh kosong")
            return
        }
        if self.alamatTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "kolom alamat tidak boleh kosong")
            return
        }
        if self.teleponTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "kolom telepon tidak boleh kosong")
            return
        }
        if self.emailTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "kolom email tidak boleh kosong")
            return
        }
        
        let param: [String: String] = [
            "nama_customer": self.namaTextField.text!,
            "Alamat": self.alamatTextField.text!,
            "nomor_tlp": self.teleponTextField.text!,
            "email": self.emailTextField.text!
        ]
        
        if DBWrapper.sharedInstance.doInsertCustomer(custData: param) == true {
            Utilities.sharedInstance.showAlert(obj: self, title: "BERHASIL", message: "Berhasil menginput data customer")
        } else {
            Utilities.sharedInstance.showAlert(obj: self, title: "GAGAL", message: "Gagal menginput data customer")
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
