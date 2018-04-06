//
//  UbahWisataViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class UbahWisataViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var namaWisataTextField: UITextField!
    @IBOutlet var kotaWisataTextField: UITextField!
    
    var selectedWisata: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.namaWisataTextField.text = self.selectedWisata?["wisata"]     // menampilkan data ke text field
        self.kotaWisataTextField.text = self.selectedWisata?["kota"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        //Validasi
        if self.namaWisataTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Nama Wisata tidak boleh kosong")
            return
        }
        if self.kotaWisataTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Kota Wisata tidak boleh kosong")
            return
        }
        
        let param: [String: String] = [
            "id": (self.selectedWisata?["id"])!,
            "nama_wisata": self.namaWisataTextField.text!,
            "kota_wisata": self.kotaWisataTextField.text!
            
        ]
        
        if DBWrapper.sharedInstance.doUpdateWisata(Wisata: param) == true {
            // Succes update movie
            let alert = UIAlertController(title: "SUKSES", message: "Data Wisata Berhasil Diubah!", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                
                // dismiss alert
                alert.dismiss(animated: true, completion: nil)
                
                //pop view controller
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            // Failed update movie
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Something wrong happened")
        }
        
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
