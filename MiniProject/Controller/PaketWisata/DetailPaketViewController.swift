//
//  DetailPaketViewController.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/4/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class DetailPaketViewController: UIViewController {
    
    @IBOutlet var namaPaketLabel: UILabel!
    @IBOutlet var namaWisataLabel: UILabel!
    @IBOutlet var kotaWisata: UILabel!
    @IBOutlet var penginapanLabel: UILabel!
    @IBOutlet var lamaWisataLabel: UILabel!
    @IBOutlet var jenisKendaraan: UILabel!
    @IBOutlet var transportasiLabel: UILabel!
    @IBOutlet var kapasitasLabel: UILabel!
    @IBOutlet var hargaLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var stockPaket: UILabel!
    @IBOutlet var gambar: UIImageView!
    
    var selectedPaket: [String: String]?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.namaPaketLabel?.text = self.selectedPaket?["namaPaket"]
        self.namaWisataLabel?.text = self.selectedPaket?["nama_wisata"]
        self.kotaWisata?.text = self.selectedPaket?["kota_wisata"]
        self.penginapanLabel?.text = self.selectedPaket?["nama_penginapan"]
        self.lamaWisataLabel?.text = self.selectedPaket?["lama_wisata"]
        self.jenisKendaraan?.text = self.selectedPaket?["jenis_kendaraan"]
        self.transportasiLabel?.text = self.selectedPaket?["nama_kendaraan"]
        self.kapasitasLabel?.text = self.selectedPaket?["kapasitas"]
        self.hargaLabel?.text = self.selectedPaket?["harga"]
        self.statusLabel?.text = self.selectedPaket?["status"]
        self.stockPaket?.text = self.selectedPaket?["stock"]
        
        
        let dataDecoded:NSData = NSData(base64Encoded: (self.selectedPaket?["gambar"])!, options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        self.gambar.image = decodedimage
        
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
