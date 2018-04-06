//
//  ReservasiTableViewCell.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 3/29/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class ReservasiTableViewCell: UITableViewCell {
    
    @IBOutlet var namaCustomerLabel: UILabel!
    @IBOutlet var namaPaketLabel: UILabel!
    @IBOutlet var tanggalLabel: UILabel!
    @IBOutlet var statusPembayaranLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
