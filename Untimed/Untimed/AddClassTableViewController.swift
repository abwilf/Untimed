//
//  AddClassTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/26/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddClassTableViewController: UITableViewController {
    
    var className: String? = nil
    
    @IBAction func didChangeClassTitle(sender: UITextField) {
        if let name = sender.text {
            className = name
        }
    }
    
}