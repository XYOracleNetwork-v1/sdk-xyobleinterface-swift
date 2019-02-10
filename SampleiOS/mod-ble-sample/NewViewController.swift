//
//  NewViewController.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/9/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct ByteItem {
        let title : String
        let desc : String
        
        init(title : String, desc: String) {
            self.title = title
            self.desc = desc
        }
    }
    
    
    var items : [ByteItem] = []
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "bcell",for: indexPath as IndexPath) as! BytesTableViewCell
        let item = items[indexPath.row]
        
        cell.title.text = item.title
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showItem") {
            let upcoming: ItemViewController = segue.destination as! ItemViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            upcoming.item = items[indexPath.row]
            
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showItem", sender: self)
    }
    
    
    
}
