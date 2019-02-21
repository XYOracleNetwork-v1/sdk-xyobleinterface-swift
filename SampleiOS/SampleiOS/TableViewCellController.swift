//
//  TableViewCellController.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/8/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import UIKit

class TableViewCellController: UITableViewCell {
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

