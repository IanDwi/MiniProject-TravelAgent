//
//  AddReservasiViewController.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class AddReservasiViewController: UIViewController, UITextFieldDelegate, SelectCustomerDelegate, ListJadwalDelegate, PilihPaketDelegate{
   
    @IBOutlet var namaCustomerTextField : UITextField!
    @IBOutlet var namaPaketTextField : UITextField!
    @IBOutlet var jadwalTextField : UITextField!
    @IBOutlet var stockLabel : UILabel!
    
    var selectedCustomer: [String: String]?
    var selectedJadwal: [String: String]?
    var selectedPaket: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonDidPushed(_ sender: UIButton){
        if self.namaCustomerTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "kolom nama tidak boleh kosong")
            return
        }
        if self.namaPaketTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "paket tidak boleh kosong")
            return
        }
        if self.jadwalTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Jadwal tidak boleh kosong")
            return
        }
        
        
        let param: [String: String] = [
            "id_customer": self.selectedCustomer!["id"]!,
            "id_paket": self.selectedPaket!["id"]!,
            "id_jadwal": self.selectedJadwal!["id"]!
            
        ]
        
        var stock = Int(self.selectedPaket!["stock"]!)!
            stock -= 1
        self.stockLabel?.text = String(stock)
        
        
        let updatestock: [String: String] = [
            "id": (self.selectedPaket?["id"])!,
            "stock": (self.stockLabel?.text!)!
        ]
        
        
        if (stockLabel.text == String(0)) {
            DBWrapper.sharedInstance.doUpdatePaketStatus(Paket: selectedPaket!, status: "Habis")
        } 
        
        if DBWrapper.sharedInstance.doUpdatePaketStock(Paket: updatestock) == true {
            
        }
        
        
        if DBWrapper.sharedInstance.doInsertReservasi(reservasi: param) == true {
            
            Utilities.sharedInstance.showAlert(obj: self, title: "BERHASIL", message: "Berhasil membuat reservasi")
            
            
        } else {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Gagal membuat reservasi")
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.namaCustomerTextField{
            self.performSegue(withIdentifier: "SelectCustomerSegue", sender: self)
            return false
        }
        if textField == self.jadwalTextField{
            self.performSegue(withIdentifier: "ListJadwalSegue", sender: self)
            return false
        }
        if textField == self.namaPaketTextField{
            self.performSegue(withIdentifier: "PilihPaketSegue", sender: self)
            return false
        }
        return true
    }
    
    func listJadwalWillDismiss(param: [String : String]) {
        self.jadwalTextField.text = param["tanggal"]
        self.selectedJadwal = param
    }
    
    func selectCustomerWillDismiss(param: [String: String]){
        self.namaCustomerTextField.text = param["nama_customer"]
        self.selectedCustomer = param
    }
    func pilihPaketWillDismiss(param: [String: String]){
        self.namaPaketTextField.text = param["namaPaket"]
        self.selectedPaket = param
        self.stockLabel.text = param["stock"]
        self.selectedPaket = param
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SelectCustomerSegue"{
            let obj = segue.destination as! SelectCustomerViewController
            obj.delegate = self
        }
        if segue.identifier == "ListJadwalSegue"{
            let obj = segue.destination as! ListJadwalViewController
            obj.delegate = self
        }
        if segue.identifier == "PilihPaketSegue"{
            let obj = segue.destination as! PilihPaketViewController
            obj.delegate = self
        }
    }
}
