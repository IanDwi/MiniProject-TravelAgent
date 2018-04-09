//
//  PilihPenginapanViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit
protocol SelectPenginapanDelegate {
    func selectPenginapanWillDismiss(param: [String: String])
}
class PilihPenginapanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var hapusButton: UIButton!
    @IBOutlet var ubahButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    var penginapan = [[String: String]]()
    var selectedPenginapan: [String: String]?
    var delegate: SelectPenginapanDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tmpbtn = UIBarButtonItem()
        self.navigationItem.leftBarButtonItem = tmpbtn
        self.hapusButton.isHidden = true
        self.ubahButton.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Fetch all users
        if let data = DBWrapper.sharedInstance.fetchPenginapan() {
            self.penginapan = data
            self.tableView.reloadData()
            self.hapusButton.isHidden = true
            self.ubahButton.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.penginapan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let person = self.penginapan[indexPath.row]
        cell.textLabel?.text = person["nama_penginapan"]
        cell.detailTextLabel?.text = person["kualitas"]
        
        if self.selectedPenginapan != nil && person["nama_penginapan"] == self.selectedPenginapan!["nama_penginapan"] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPenginapan = self.penginapan[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
        self.hapusButton.isHidden = false
        self.ubahButton.isHidden = false
    }
    
    @IBAction func selesaiButton(_ sender: UIBarButtonItem) {
        if selectedPenginapan == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Pilih salah satu")
            return
        }
        if self.delegate != nil && self.selectedPenginapan != nil {
            self.delegate?.selectPenginapanWillDismiss(param: selectedPenginapan!)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "TambahPenginapanSegue", sender: self)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "UbahPenginapanSegue", sender: self)
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: self.selectedPenginapan?["nama_penginapan"], message: "Apa kamu yakin?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel) {
            (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        let yesAction = UIAlertAction(title: "Ya", style: UIAlertActionStyle.default) {
            (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        
        
            let param: [String: String] = [                         // parameter
                "id": (self.selectedPenginapan?["id"])!
            ]
            if DBWrapper.sharedInstance.doDeletePenginapan(Penginapan: param) == true {
                // Succes update 
                let alert = UIAlertController(title: "SUKSES", message: "Penginapan Dihapus", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                    //reload controller
                    if let data = DBWrapper.sharedInstance .fetchPenginapan() {
                        self.penginapan = data
                        self.tableView.reloadData()
                        self.hapusButton.isHidden = true
                        self.ubahButton.isHidden = true
                        self.selectedPenginapan = nil
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
            if let data = DBWrapper.sharedInstance.fetchPenginapan(){
                self.penginapan = data
                self.tableView.reloadData()
            }
            
        }
        else
        {
            if let data = DBWrapper.sharedInstance.searchPenginapan(search: cari)
            {
                self.penginapan = data
                self.tableView.reloadData()
            }
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UbahPenginapanSegue" {
            let obj = segue.destination as! UbahPenginapanViewController
            obj.selectedPenginapan = self.selectedPenginapan
        }
    }
    

}
