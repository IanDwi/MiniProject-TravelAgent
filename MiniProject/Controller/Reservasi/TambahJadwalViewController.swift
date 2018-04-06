//
//  TambahJadwalViewController.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class TambahJadwalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tanggalTextField : UITextField!
    
    var dateFormatter = DateFormatter()
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.dateFormatter.dateFormat = "hh:mm"
//        self.setUpTimePicker()
        
        self.dateFormatter.dateFormat =
        "dd-MM-yyyy (hh:mm)"
        
        self.setUpDatePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setUpTimePicker(){
//        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200)
//        self.datePicker = UIDatePicker(frame: frame)
//        self.datePicker?.backgroundColor = UIColor.white
//        self.datePicker?.datePickerMode = .time
//
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(timePickerDoneButtonDidPushed))
//        toolbar.setItems([doneButton], animated: false)
//
//        self.jamTextField.inputAccessoryView = toolbar
//        self.jamTextField.inputView = self.datePicker
//    }
    
    func setUpDatePicker(){
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200)
        self.datePicker = UIDatePicker(frame: frame)
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.datePickerMode = .dateAndTime
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(datePickerDoneButtonDidPushed))
        toolbar.setItems([doneButton], animated: false)
        
        self.tanggalTextField.inputAccessoryView = toolbar
        self.tanggalTextField.inputView = self.datePicker
    }
    
    @objc func datePickerDoneButtonDidPushed() {
        let selectedDate = self.datePicker?.date
        self.tanggalTextField.text = self.dateFormatter.string(from: selectedDate!)
        self.tanggalTextField.resignFirstResponder()
        
    }
    
    @IBAction func saveButtonDidPushed(_ sender: UIButton){
        // validation
        if self.tanggalTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "kolom jadwal tidak boleh kosong")
            return
        }
      
        let param: [String: String] = [
            "tanggal": self.tanggalTextField.text!
            ]
        
        if DBWrapper.sharedInstance.doInsertJadwal(jadwal: param) == true {
            Utilities.sharedInstance.showAlert2(obj: self, title: "BERHASIL", message: "Berhasil menambah jadwal")
        } else {
            Utilities.sharedInstance.showAlert(obj: self, title: "GAGAL", message: "Gagal menambah jadwal")
        }
    }
    
//    @objc func timePickerDoneButtonDidPushed() {
//
//        let selectedTime = self.datePicker?.date
//        self.jamTextField.text = self.dateFormatter.string(from: selectedTime!)
//        self.jamTextField.resignFirstResponder()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
