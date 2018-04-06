//
//  TambahTransportasiViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class TambahTransportasiViewController: UIViewController {
    
    @IBOutlet var jenisTextField: UITextField!
    @IBOutlet var namaTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if self.jenisTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Jenis Transportasi tidak boleh kosong")
            return
        }
        if self.namaTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Nama Transportasi tidak boleh kosong")
            return
        }
        
        let param: [String: String] = [
            
            "jenis_kendaraan": self.jenisTextField.text!,
            "nama_kendaraan": self.namaTextField.text!
            
        ]
        
        if DBWrapper.sharedInstance.doInsertTransportasi(Transportasi: param) == true {
            Utilities.sharedInstance.showAlert(obj: self, title: "SUKSES", message: "Sukses menambah data")
            self.navigationController?.popViewController(animated: true)
        }
        else {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Gagal menambah data")
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
