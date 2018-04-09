//
//  PaketWisataViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class PaketWisataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    
    
    var paket = [[String: String]]()
    var selectedPaket: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Fetch all users
        
        //let userid = self.selectedUser!["id"]!
        if let data = DBWrapper.sharedInstance.fetchPaket() {
            self.paket = data
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tambahPaketButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "TambahPaketSegue", sender: self)
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
            
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let paket = self.paket[indexPath.row]
        self.selectedPaket = paket
        
        // create action sheet
        let actionSheet = UIAlertController(title: "Pilih Menu", message: self.selectedPaket?["namaPaket"], preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // create edit action
        let detailAction = UIAlertAction(title: "Detail Paket", style: UIAlertActionStyle.default) {
            (action) in
            // TODO: Go to EditMovieViewController
            self.performSegue(withIdentifier: "DetailPaketSegue", sender: self)
        }
        let editAction = UIAlertAction(title: "Ubah", style: UIAlertActionStyle.default) {
            (action) in
            // TODO: Go to EditMovieViewController
            self.performSegue(withIdentifier: "EditPaketSegue", sender: self)
        }
        let deleteAction = UIAlertAction(title: "Hapus", style: UIAlertActionStyle.default) {
            (action) in
            
            // do delete
            let actionSheet = UIAlertController(title: self.selectedPaket?["namaPaket"], message: "Apa kamu yakin?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel) {
                (action) in
                actionSheet.dismiss(animated: true, completion: nil)
            }
            
            let yesAction = UIAlertAction(title: "Ya", style: UIAlertActionStyle.default) {
                (action) in
                actionSheet.dismiss(animated: true, completion: nil)
                
                let param: [String: String] = [                         // parameter
                    "id": (self.selectedPaket?["id"])!
                ]
                if DBWrapper.sharedInstance.doDeletePaket(Paket: param) == true {
                    // Succes update
                    let alert = UIAlertController(title: "SUKSES", message: "Paket Dihapus!", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                        //reload controller
                        if let data = DBWrapper.sharedInstance .fetchPaket() {
                            self.paket = data
                            self.tableView.reloadData()
                        }
                        
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    // Failed delete
                    Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Ada masalah!")
                }
            }
            
            actionSheet.addAction(yesAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        // create cancel action
        let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel) {
            (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        // add action to action sheet
        actionSheet.addAction(detailAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        // show action sheet
        self.present(actionSheet, animated: true, completion: nil)
        
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
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
        if segue.identifier == "EditPaketSegue" {
            let obj = segue.destination as! EditPaketViewController
            obj.selectedPaket = self.selectedPaket
            
            obj.selectedWisata = [
                "id": self.selectedPaket!["id_wisata"]!,
                "nama_wisata": self.selectedPaket!["nama_wisata"]!
            ]
            obj.selectedPenginapan = [
                "id": self.selectedPaket!["id_penginapan"]!,
                "nama_penginapan": self.selectedPaket!["nama_penginapan"]!
            ]
            obj.selectedTransportasi = [
                "id": self.selectedPaket!["id_transportasi"]!,
                "nama_kendaraan": self.selectedPaket!["nama_kendaraan"]!
            ]
        }
    }
    

}
