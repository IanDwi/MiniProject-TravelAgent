//
//  DetailWisataViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/9/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class DetailWisataViewController: UIViewController {
    
    
    @IBOutlet var namaWisataLabel: UILabel!
    @IBOutlet var kotaWisata: UILabel!
    @IBOutlet var deskripsi: UITextView!
    
    var selectedWisata: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.namaWisataLabel?.text = self.selectedWisata?["wisata"]
        self.kotaWisata?.text = self.selectedWisata?["kota"]
        self.deskripsi?.text = self.selectedWisata?["deskripsi"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
