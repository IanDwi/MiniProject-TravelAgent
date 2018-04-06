//
//  PaketWisataTableViewCell.swift
//  MiniProject
//
//  Created by Mac Mini-07 on 4/3/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class PaketWisataTableViewCell: UITableViewCell {
    
    @IBOutlet var namaPaketLabel: UILabel!
    @IBOutlet var namaWisataLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var hargaLabel: UILabel!
    @IBOutlet var gambar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
