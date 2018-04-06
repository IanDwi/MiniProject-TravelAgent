//
//  ListJadwalViewController.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit
protocol ListJadwalDelegate {
    func listJadwalWillDismiss(param: [String: String])
}

class ListJadwalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var jadwal = [[String: String]]()
    var selectedJadwal: [String: String]?
    var delegate: ListJadwalDelegate?
    
    @IBOutlet var hapusButton: UIButton!
    @IBOutlet var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hapusButton.isHidden = true
        self.editButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = DBWrapper.sharedInstance.fetchJadwal(){
            self.jadwal = data
            self.tableView.reloadData()
            self.hapusButton.isHidden = true
            self.editButton.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editButtonDidPushed(_ sender: UIButton){
        self.performSegue(withIdentifier: "EditJadwalSegue", sender: self)
    }
    
    @IBAction func addButtonDidPushed(_ sender: UIButton){
        
        self.performSegue(withIdentifier: "TambahJadwalSegue", sender: self)
    }
    
    @IBAction func doneButtonDidPushed(_ sender: UIBarButtonItem){
        if selectedJadwal == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Pilih salah satu")
            return
        }
        if self.delegate != nil && self.selectedJadwal != nil{
            self.delegate?.listJadwalWillDismiss(param: self.selectedJadwal!)
        }
        self.navigationController?.popViewController(animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "EditJadwalSegue"{
            let obj = segue.destination as! EditJadwalViewController
            obj.selectedJadwal = self.selectedJadwal
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jadwal.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JadwalCell", for: indexPath) as! ListJadwalTableViewCell
        
        let jadwal = self.jadwal[indexPath.row]
        
        cell.tglLabel?.text = jadwal["tanggal"]
        
        if self.selectedJadwal != nil && jadwal["tanggal"] == self.selectedJadwal!["tanggal"]{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedJadwal = self.jadwal[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        
        let alertConfirm = UIAlertController(title: "Hapus Jadwal", message: "Apa kamu yakin?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelDelete = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in alertConfirm.dismiss(animated: true, completion: nil) })
        
        let okDelete = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action)
            in alertConfirm.dismiss(animated: true, completion: nil)
            
            let param: [String: String] = [
                "id": (self.selectedJadwal?["id"])!
            ]
            if DBWrapper.sharedInstance.doDeleteJadwal(jadwal: param) == true {
                if let data = DBWrapper.sharedInstance.fetchJadwal(){
                    self.jadwal = data
                    self.tableView.reloadData()
                    self.hapusButton.isHidden = true
                    self.editButton.isHidden = true
                    self.selectedJadwal = nil
                }
                
            } else {
                Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Gagal menghapus jadwal")
            }
        })
        alertConfirm.addAction(cancelDelete)
        alertConfirm.addAction(okDelete)
        self.present(alertConfirm, animated: true, completion: nil)
            
        }
    
 

}
