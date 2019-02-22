//
//  BytesTableViewCell.swift
//  mod-ble-sample
//
//  Created by Carter Harrison on 2/10/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import UIKit

class BytesTableViewCell: UITableViewCell {
    @IBOutlet weak var title : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
