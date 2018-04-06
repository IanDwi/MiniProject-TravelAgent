//
//  UbahPenginapanViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class UbahPenginapanViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var namaPenginapanTextField: UITextField!
    @IBOutlet var kualitasTextField: UITextField!
    
    var selectedPenginapan: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.namaPenginapanTextField.text = self.selectedPenginapan?["nama_penginapan"]     // menampilkan data ke text field
        self.kualitasTextField.text = self.selectedPenginapan?["kualitas"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        //Validasi
        if self.namaPenginapanTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Nama Penginapan tidak boleh kosong")
            return
        }
        if self.kualitasTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Kualitas tidak boleh kosong")
            return
        }
        
        let param: [String: String] = [
            "id": (self.selectedPenginapan?["id"])!,
            "nama_penginapan": self.namaPenginapanTextField.text!,
            "kualitas": self.kualitasTextField.text!
            
        ]
        
        if DBWrapper.sharedInstance.doUpdatePenginapan(Penginapan: param) == true {
            // Succes update movie
            let alert = UIAlertController(title: "SUKSES", message: "Data Penginapan Berhasil Diubah!", preferredStyle: UIAlertControllerStyle.alert)
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
