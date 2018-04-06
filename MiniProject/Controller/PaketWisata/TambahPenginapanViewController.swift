//
//  TambahPenginapanViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class TambahPenginapanViewController: UIViewController {
    
    @IBOutlet var namaPenginapanTextField: UITextField!
    @IBOutlet var kualitasTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if self.namaPenginapanTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Nama Penginapan tidak boleh kosong")
            return
        }
        if self.kualitasTextField.text == "" {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Kualitas tidak boleh kosong")
            return
        }
        
        let param: [String: String] = [
            
            "nama_penginapan": self.namaPenginapanTextField.text!,
            "kualitas": self.kualitasTextField.text!
            
        ]
        
        if DBWrapper.sharedInstance.doInsertPenginapan(Penginapan: param) == true {
            Utilities.sharedInstance.showAlert(obj: self, title: "SUCCES", message: "Sukses menambah data")
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
