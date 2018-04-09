//
//  PilihPaketViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/4/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit
protocol PilihPaketDelegate {
    func pilihPaketWillDismiss(param: [String: String])
}

class PilihPaketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var paket = [[String: String]]()
    var selectedPaket: [String: String]?
    var delegate: PilihPaketDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Fetch all users
        
       
        if let data = DBWrapper.sharedInstance.fetchPaket() {
            self.paket = data
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonDidPushed(_ sender: UIBarButtonItem){
        if selectedPaket == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Pilih salah satu")
            return
        }
        if self.delegate != nil && self.selectedPaket != nil{
            self.delegate?.pilihPaketWillDismiss(param: self.selectedPaket!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaketWisataTableViewCell", for: indexPath) as! PaketWisataTableViewCell
        let paketwisata = self.paket[indexPath.row]
        
        cell.namaPaketLabel?.text = paketwisata["namaPaket"]
        cell.namaWisataLabel?.text = paketwisata["nama_wisata"]
        cell.hargaLabel?.text = paketwisata["harga"]
        cell.statusLabel?.text = paketwisata["status"]
        
        let dataDecoded:NSData = NSData(base64Encoded: (paketwisata["gambar"])!, options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        cell.gambar.image = decodedimage
        
        if self.selectedPaket != nil && paketwisata["namaPaket"] == self.selectedPaket!["namaPaket"]{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPaket = self.paket[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
      
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailPaketSegue" {
            let obj = segue.destination as! DetailPaketViewController
            obj.selectedPaket = self.selectedPaket
        }
    }
    
    
}
