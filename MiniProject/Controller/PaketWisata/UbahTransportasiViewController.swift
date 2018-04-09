//
//  UbahTransportasiViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class UbahTransportasiViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var jenisTextField: UITextField!
    @IBOutlet var namaTextField: UITextField!
    
    var selectedTransportasi: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.jenisTextField.text = self.selectedTransportasi?["jenis"]     // menampilkan data ke text field
        self.namaTextField.text = self.selectedTransportasi?["nama"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        //Validasi
        if self.jenisTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Jenis Kendaraan Penginapan tidak boleh kosong")
            return
        }
        if self.namaTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Nama Kendaraan tidak boleh kosong")
            return
        }
        
        let param: [String: String] = [
            "id": (self.selectedTransportasi?["id"])!,
            "nama_penginapan": self.jenisTextField.text!,
            "kualitas": self.namaTextField.text!
            
        ]
        
        if DBWrapper.sharedInstance.doUpdateTransportasi(Transportasi: param) == true {
            // Succes update
            let alert = UIAlertController(title: "SUKSES", message: "Data Transportasi Berhasil Diubah!", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                
                // dismiss alert
                alert.dismiss(animated: true, completion: nil)
                
                //pop view controller
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            // Failed update
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Ada Masalah!")
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
