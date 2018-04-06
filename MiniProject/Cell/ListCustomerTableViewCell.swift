//
//  ListCustomerTableViewCell.swift
//  MiniProject
//
//  Created by Mac Mini-05 on 4/2/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit

class ListCustomerTableViewCell: UITableViewCell {

    @IBOutlet var namaLabel: UILabel!
    @IBOutlet var teleponLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
