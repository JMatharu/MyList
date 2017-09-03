//
//  HomeViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-08-13.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation
import UIKit
import PMAlertController

class HomeViewController: UITableViewController {
    @IBOutlet weak var addItem: UINavigationItem!
    override func viewDidLoad() {
        self.title = "Month List"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.HomeListViewControllerTableCellIdentifier, for: indexPath)
        cell.textLabel?.text = "Hello"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func addItem(_ sender: Any) {
        let alert = PMAlertController.init(withTitle: "Enter Month and Year", withDescription: "")
        alert.addAction(<#T##alertAction: PMAlertAction##PMAlertAction#>)
    }
}
