//
//  HamburgerTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/11/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class HamburgerTableViewController: UITableViewController {

    var tmObj = TaskManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    @IBAction func unwindFromSettings(sender: UIStoryboardSegue) {
        if let stvc = sender.sourceViewController as? SettingsTableViewController {
            tmObj.firstWorkingHour = stvc.fwh
            tmObj.lastWorkingHour = stvc.lwh
            
            // this is what was missing
            tmObj.setSettingsArray()
            
            tmObj.save()
            
            assert(tmObj.settingsArray.count == 2, "\n\n\nsave and load settingsArray from disc failed\n\n")
            
            // test if saving is working alright
            tmObj.loadFromDisc()
            assert(tmObj.settingsArray.count == 2, "\n\n\nsave and load settingsArray from disc failed\n\n")
            
            tableView.reloadData()
        }
    }
    
    
}
