//
//  EditJadwalViewController.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class EditJadwalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var jadwalTextField : UITextField!
    
    var selectedJadwal: [String: String]?
    var dateFormatter = DateFormatter()
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.title = "Ubah Jadwal"
//
//        self.jadwalTextField.text = self.selectedJadwal?["tanggal"]
        self.dateFormatter.dateFormat =
        "'Tanggal : 'dd-MM-yyyy | 'Jam : ' hh:mm"
        
        self.setUpDatePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpDatePicker(){
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200)
        self.datePicker = UIDatePicker(frame: frame)
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.datePickerMode = .dateAndTime
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(datePickerDoneButtonDidPushed))
        toolbar.setItems([doneButton], animated: false)
        
        self.jadwalTextField.inputAccessoryView = toolbar
        self.jadwalTextField.inputView = self.datePicker
    }
    
    @objc func datePickerDoneButtonDidPushed() {
        let selectedDate = self.datePicker?.date
        self.jadwalTextField.text = self.dateFormatter.string(from: selectedDate!)
        self.jadwalTextField.resignFirstResponder()
        
    }
    
    @IBAction func updateButtonDidPushed(_ sender: UIButton){
        if self.jadwalTextField.text == ""{
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "kolom jadwal tidak boleh kosong")
            return
        }
    
        
        let param: [String: String] = [
            "id": (self.selectedJadwal?["id"])!,
            "tanggal": self.jadwalTextField.text!
            ]
        
        if DBWrapper.sharedInstance.doUpdateJadwal(jadwal: param) == true {
            let alert = UIAlertController(title: "BERHASIL", message: "Jadwal Berhasil di Ubah!", preferredStyle: UIAlertControllerStyle.alert)
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
