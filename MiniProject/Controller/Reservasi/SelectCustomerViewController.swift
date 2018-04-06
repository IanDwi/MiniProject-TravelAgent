//
//  SelectCustomerViewController.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit
protocol SelectCustomerDelegate {
    func selectCustomerWillDismiss(param: [String: String])
}

class SelectCustomerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    var customer = [[String: String]]()
    var selectedCustomer: [String: String]?
    var delegate: SelectCustomerDelegate?
    
    
    
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
    
   
    
    @IBAction func doneButtonDidPushed(_ sender: UIBarButtonItem){
        if selectedCustomer == nil {
            Utilities.sharedInstance.showAlert(obj: self, title: "ERROR", message: "Pilih salah satu")
            return
        }
        if self.delegate != nil && self.selectedCustomer != nil{
            self.delegate?.selectCustomerWillDismiss(param: self.selectedCustomer!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.customer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PilihPelanggan", for: indexPath) as! SelectCustomerTableViewCell
        let person = self.customer[indexPath.row]
        cell.namaLabel?.text = person["nama_customer"]
        cell.teleponLabel?.text = person["nomor_tlp"]
        
        if self.selectedCustomer != nil && person["nama_customer"] == self.selectedCustomer!["nama_customer"]{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCustomer = self.customer[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
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
 

}
