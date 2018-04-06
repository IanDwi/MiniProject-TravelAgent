//
//  ReservasiViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class ReservasiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var tableView: UITableView!
    var reservasi = [[String: String]]()
    var selectedPaket: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = DBWrapper.sharedInstance.fetchReservasi() {
            self.reservasi = data
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonDidPushed(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "AddReservasiSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let reservasi = self.reservasi[indexPath.row]
        self.selectedPaket = reservasi
        
        // create action sheet
        let actionSheet = UIAlertController(title: "Pilih Menu", message: self.selectedPaket?["namaPaket"], preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // create edit action
        let detailAction = UIAlertAction(title: "Detail Reservasi", style: UIAlertActionStyle.default) {
            (action) in
            // TODO: Go to EditViewController
            self.performSegue(withIdentifier: "DetailReservasiSegue", sender: self)
        }
        let editAction = UIAlertAction(title: "Ubah Status (LUNAS)", style: UIAlertActionStyle.default) {
            (action) in
            // TODO: Go to EditViewController
            
                if DBWrapper.sharedInstance.doUpdateStatus(ordersId: self.selectedPaket!, status: "LUNAS") == true {
                    
                    if let data = DBWrapper.sharedInstance.fetchReservasi() {
                        self.reservasi = data
                        self.tableView.reloadData()
                    }
                }
                
            
            
        }
        let deleteAction = UIAlertAction(title: "Hapus", style: UIAlertActionStyle.default) {
            (action) in
            
            // do delete movie
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
                        if let data = DBWrapper.sharedInstance .fetchReservasi() {
                            self.reservasi = data
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
        
        if selectedPaket!["status"] != "LUNAS" {
            actionSheet.addAction(editAction)
        }
        
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
        if segue.identifier == "DetailReservasiSegue" {
            let obj = segue.destination as! DetailReservasiViewController
            obj.selectedPaket = self.selectedPaket
        }
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return reservasi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reservasi", for: indexPath) as! ReservasiTableViewCell
        let person = self.reservasi[indexPath.row]
        cell.namaCustomerLabel?.text = person["nama_customer"]
        cell.namaPaketLabel?.text = person["namaPaket"]
        cell.statusPembayaranLabel?.text = person["status"]
        cell.tanggalLabel?.text = person["tanggal"]
        return cell
    }

}
