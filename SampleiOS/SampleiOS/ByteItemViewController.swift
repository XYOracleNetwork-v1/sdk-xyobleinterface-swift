//
//  ItemViewController.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/9/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import UIKit

class ByteItemViewController: UIViewController {
    @IBOutlet weak var text : UILabel!
    var item : ByteListViewController.ByteItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = item?.title
    
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        text.text = item?.desc
//        text.sizeToFit()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

