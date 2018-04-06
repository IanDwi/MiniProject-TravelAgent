//
//  ListCustomerViewController.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class ListCustomerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var customer = [[String: String]]()
    var selectedCustomer: [String: String]?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = DBWrapper.sharedInstance.fetchCustomer(){
            self.customer = data
            self.tableView.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonDidPushed(_ sender: UIBarButtonItem){
        
        self.performSegue(withIdentifier: "AddCustomerSegue", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditCustSegue"{
            let obj = segue.destination as! UpdateCustomerViewController
            obj.selectedCustomer = self.selectedCustomer
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customer.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaftarPelanggan", for: indexPath) as! ListCustomerTableViewCell
        
        let customer = self.customer[indexPath.row]
        
        cell.namaLabel?.text = customer["nama_customer"]
        cell.teleponLabel?.text = customer["nomor_tlp"]
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let customer = self.customer[indexPath.row]
        self.selectedCustomer = customer
        
        let actionSheet = UIAlertController(title: "Action", message: self.selectedCustomer?["nama_customer"], preferredStyle: UIAlertControllerStyle.actionSheet)
        let editAction = UIAlertAction(title: "Ubah", style: UIAlertActionStyle.default) {
            (action) in
            self.performSegue(withIdentifier: "EditCustSegue", sender: self)
        }
        let deleteAction = UIAlertAction(title: "Hapus", style: UIAlertActionStyle.default) {
            (action) in
            // delete confirm
            actionSheet.dismiss(animated: true, completion: nil)
            
            let alertConfirm = UIAlertController(title: self.selectedCustomer?["nama_customer"]!, message: "Apakah anda yakin?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelDelete = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel, handler: { (action) in alertConfirm.dismiss(animated: true, completion: nil)
                
            })
            let okDelete = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action)
                in alertConfirm.dismiss(animated: true, completion: nil)
                
                let param: [String: String] = [                         // parameter
                    "id": (self.selectedCustomer?["id"])!
                ]
                if DBWrapper.sharedInstance.doDeleteCustomer(custId: param) == true {
                    if let data = DBWrapper.sharedInstance.fetchCustomer(){
                        self.customer = data
                        self.tableView.reloadData()
                    }
                    
                } else {
                    Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Gagal menghapus pelanggan")
                }
            })
            alertConfirm.addAction(cancelDelete)
            alertConfirm.addAction(okDelete)
            self.present(alertConfirm, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.default) {
            (action) in actionSheet.dismiss(animated: true, completion: nil)
        }
        // add action sheet
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        
        // show action sheet
        self.present(actionSheet, animated: true, completion: nil)
        
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }
 

}

