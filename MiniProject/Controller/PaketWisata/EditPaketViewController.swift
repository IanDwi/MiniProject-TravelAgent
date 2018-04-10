//
//  EditPaketViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/4/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class EditPaketViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, SelectWisataDelegate, SelectPenginapanDelegate, SelectTransportasiDelegate {

    @IBOutlet var namaPaketTextField: UITextField!
    @IBOutlet var lamaWisataTextField: UITextField!
    @IBOutlet var kapasitasTextField: UITextField!
    @IBOutlet var hargaTextField: UITextField!
    @IBOutlet var namaWisataTextField: UITextField!
    @IBOutlet var namaPenginapanTextField: UITextField!
    @IBOutlet var namaTransportasiTextField: UITextField!
    @IBOutlet var stockPaket: UITextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    var selectedPaket: [String: String]?
    var selectedWisata: [String: String]?
    var selectedPenginapan: [String: String]?
    var selectedTransportasi: [String: String]?
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imagePicked: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.namaPaketTextField?.text = self.selectedPaket?["namaPaket"]
        self.lamaWisataTextField?.text =  self.selectedPaket?["lama_wisata"]
        self.kapasitasTextField?.text = self.selectedPaket?["kapasitas"]
        self.hargaTextField?.text = self.selectedPaket?["harga"]
        self.namaWisataTextField?.text = self.selectedPaket?["nama_wisata"]
        self.namaPenginapanTextField?.text = self.selectedPaket?["nama_penginapan"]
        self.namaTransportasiTextField?.text = self.selectedPaket?["nama_kendaraan"]
        self.stockPaket?.text = self.selectedPaket?["stock"]
        
        let dataDecoded:NSData = NSData(base64Encoded: (self.selectedPaket?["gambar"])!, options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        self.imagePicked.image = decodedimage
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        if self.selectedWisata == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Wisata tidak boleh kosong")
            return
        }
        if self.selectedPenginapan == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Penginapan tidak boleh kosong")
            return
        }
        if self.selectedTransportasi == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Transportasi tidak boleh kosong")
            return
        }
        if self.namaPaketTextField.text == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Nama Paket tidak boleh kosong")
            return
        }
        if self.lamaWisataTextField.text == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Lama Wisata tidak boleh kosong")
            return
        }
        if self.kapasitasTextField.text == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Kapasitas tidak boleh kosong")
            return
        }
        if self.hargaTextField.text == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Harga tidak boleh kosong")
            return
        }
        if self.stockPaket.text == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Stock tidak boleh kosong")
            return
        }
        if self.imagePicked.image == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Pilih Gambar tidak boleh kosong")
            return
        }
        
        let imageData:NSData = UIImagePNGRepresentation(imagePicked.image!)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        
        let data = [
            "id": (self.selectedPaket?["id"])!,
            "id_wisata": self.selectedWisata!["id"]!,
            "id_penginapan": self.selectedPenginapan!["id"]!,
            "id_transportasi": self.selectedTransportasi!["id"]!,
            "namaPaket": self.namaPaketTextField.text!,
            "lama_wisata": self.lamaWisataTextField.text!,
            "kapasitas": self.kapasitasTextField.text!,
            "harga": self.hargaTextField.text!,
            "gambar": strBase64,
            "stock": self.stockPaket.text!
        ]
        
        if DBWrapper.sharedInstance.doUpdatePaket(Paket: data) == true {
            DBWrapper.sharedInstance.doUpdatePaketStatus(Paket: selectedPaket!, status: "Tersedia")
            // succes
            Utilities.sharedInstance.showAlert2(obj: self, title: "SUKSES", message: "Paket telah diubah")
        }
        else {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Ada masalah!")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.namaWisataTextField                  // mengecek apakan uername atau movies
        {
            self.performSegue(withIdentifier: "PilihWisataSegue", sender: self)
            return false
        }
        if textField == self.namaPenginapanTextField                  // mengecek apakan uername atau movies
        {
            self.performSegue(withIdentifier: "PilihPenginapanSegue", sender: self)
            return false
        }
        if textField == self.namaTransportasiTextField                  // mengecek apakan uername atau movies
        {
            self.performSegue(withIdentifier: "PilihTransportasiSegue", sender: self)
            return false
        }
        
        return true
        
    }
    
    func selectWisataWillDismiss(param: [String: String]) {
        self.namaWisataTextField.text = param["wisata"]!
        self.selectedWisata = param
    }
    func selectPenginapanWillDismiss(param: [String: String]) {
        self.namaPenginapanTextField.text = param["nama_penginapan"]!
        self.selectedPenginapan = param
    }
    func selectTransportasiWillDismiss(param: [String: String]) {
        self.namaTransportasiTextField.text = param["jenis"]!
        self.selectedTransportasi = param
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 8
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 90.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 90.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PilihWisataSegue" {
            let obj = segue.destination as! PilihWisataViewController
            obj.delegate = self
            obj.selectedWisata = self.selectedWisata
            obj.showButtons = false
        }
        if segue.identifier == "PilihPenginapanSegue" {
            let obj = segue.destination as! PilihPenginapanViewController
            obj.delegate = self
            obj.selectedPenginapan = self.selectedPenginapan
            obj.showButtons = false
        }
        
        if segue.identifier == "PilihTransportasiSegue" {
            let obj = segue.destination as! PilihTransportasiViewController
            obj.delegate = self
            obj.selectedTransportasi = self.selectedTransportasi
            obj.showButtons = false
        }
    }
    

}
