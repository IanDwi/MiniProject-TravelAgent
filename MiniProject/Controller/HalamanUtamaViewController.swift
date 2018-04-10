//
//  HalamanUtamaViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class HalamanUtamaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tmpbtn = UIBarButtonItem()
        self.navigationItem.leftBarButtonItem = tmpbtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pilihPaket(_ sender: UIButton){
        self.performSegue(withIdentifier: "PaketSegue", sender: self)
    }
    
    @IBAction func customerButtonDidPushed(_ sender: UIButton){
        self.performSegue(withIdentifier: "ListCustomerSegue", sender: self)
    }
    
    @IBAction func reservasiButtonDidPushed(_ sender: UIButton){
        self.performSegue(withIdentifier: "ReservasiSegue", sender: self)
    }
    @IBAction func wisataButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "masterWisataSegue", sender: self)
        
    }
    @IBAction func penginapanButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "masterPenginapanSegue", sender: self)
    }
    @IBAction func transportasiButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "masterTransportasiSegue", sender: self)
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
