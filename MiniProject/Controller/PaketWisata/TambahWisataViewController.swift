//
//  TambahWisataViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class TambahWisataViewController: UIViewController {
    
    @IBOutlet var namaWisataTextField: UITextField!
    @IBOutlet var kotaWisataTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveButton(_ sender: UIButton) {
        if self.namaWisataTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Nama Wisata tidak boleh kosong")
            return
        }
        if self.kotaWisataTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Kota Wisata tidak boleh kosong")
            return
        }
        
        let param: [String: String] = [
            
            "nama_wisata": self.namaWisataTextField.text!,
            "kota_wisata": self.kotaWisataTextField.text!
            
        ]
        
        if DBWrapper.sharedInstance.doInsertWisata(Wisata: param) == true {
            Utilities.sharedInstance.showAlert2(obj: self, title: "SUKSES", message: "Sukses menambah data")
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
