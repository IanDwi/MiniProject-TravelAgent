//
//  PilihTransportasiViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit
protocol SelectTransportasiDelegate {
    func selectTransportasiWillDismiss(param: [String: String])
}

class PilihTransportasiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var hapusButton: UIButton!
    @IBOutlet var ubahButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    var transportasi = [[String: String]]()
    var selectedTransportasi: [String: String]?
    var delegate: SelectTransportasiDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hapusButton.isHidden = true
        self.ubahButton.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Fetch all users
        if let data = DBWrapper.sharedInstance.fetchTransportasi() {
            self.transportasi = data
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transportasi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let person = self.transportasi[indexPath.row]
        cell.textLabel?.text = person["jenis"]
        cell.detailTextLabel?.text = person["nama"]
        
        if self.selectedTransportasi != nil && person["jenis"] == self.selectedTransportasi!["jenis"] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTransportasi = self.transportasi[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
        self.hapusButton.isHidden = false
        self.ubahButton.isHidden = false
    }
    
    @IBAction func selesaiButton(_ sender: UIBarButtonItem) {
        if self.delegate != nil && self.selectedTransportasi != nil {
            self.delegate?.selectTransportasiWillDismiss(param: selectedTransportasi!)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "TambahTransportasiSegue", sender: self)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "UbahTransportasiSegue", sender: self)
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: self.selectedTransportasi?["jenis"], message: "Apa kamu yakin?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel) {
            (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        let yesAction = UIAlertAction(title: "Ya", style: UIAlertActionStyle.default) {
            (action) in
            actionSheet.dismiss(animated: true, completion: nil)
            
            
            let param: [String: String] = [                         // parameter
                "id": (self.selectedTransportasi?["id"])!
            ]
            if DBWrapper.sharedInstance.doDeleteTransportasi(Transportasi: param) == true {
                // Succes update movie
                let alert = UIAlertController(title: "SUKSES", message: "Penginapan Dihapus", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                    //reload controller
                    if let data = DBWrapper.sharedInstance .fetchTransportasi() {
                        self.transportasi = data
                        self.tableView.reloadData()
                    }
                    
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
                
            } else {
                
                Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Ada masalah")
            }
            
        }
        
        actionSheet.addAction(yesAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let cari = self.searchBar.text!
        if self.searchBar.text! == ""{
            if let data = DBWrapper.sharedInstance.fetchTransportasi(){
                self.transportasi = data
                self.tableView.reloadData()
            }
            
        }
        else
        {
            if let data = DBWrapper.sharedInstance.searchTransportasi(search: cari)
            {
                self.transportasi = data
                self.tableView.reloadData()
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UbahTransportasiSegue" {
            let obj = segue.destination as! UbahTransportasiViewController
            obj.selectedTransportasi = self.selectedTransportasi
        }
    }
    

}
