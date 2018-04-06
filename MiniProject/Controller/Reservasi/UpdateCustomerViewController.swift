//
//  UpdateCustomerViewController.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class UpdateCustomerViewController: UIViewController {
    
    @IBOutlet var namaTextField: UITextField!
    @IBOutlet var alamatTextField: UITextField!
    @IBOutlet var teleponTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    var selectedCustomer: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Ubah Pelanggan"
        
        self.namaTextField.text = self.selectedCustomer?["nama_customer"]
        self.alamatTextField.text = self.selectedCustomer?["Alamat"]
        self.teleponTextField.text = self.selectedCustomer?["nomor_tlp"]
        self.emailTextField.text = self.selectedCustomer?["email"]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButtonDidPushed(_ sender: UIButton){
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
            "id": (self.selectedCustomer?["id"])!,
            "nama_customer": self.namaTextField.text!,
            "Alamat": self.alamatTextField.text!,
            "nomor_tlp": self.teleponTextField.text!,
            "email": self.emailTextField.text!,
        ]
        
        if DBWrapper.sharedInstance.doUpdateCustomer(custid: param) == true {
            let alert = UIAlertController(title: "BERHASIL", message: "Data Customer Berhasil di Ubah!", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {(action)
                in
                
                // dismiss alert
                alert.dismiss(animated: true, completion: nil)
                
                // pop view controller
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "terjadi kesalahan")
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
