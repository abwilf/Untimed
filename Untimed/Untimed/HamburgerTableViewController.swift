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

    @IBAction func markCompletePressed(sender: UIButton) {
        self.performSegueWithIdentifier("Accountability Segue", sender: sender)
    }
    
    @IBAction func unwindFromSettings(sender: UIStoryboardSegue) {
        if let stvc = sender.sourceViewController as? SettingsTableViewController {
            tmObj.firstWorkingHour = stvc.fwh
            tmObj.lastWorkingHour = stvc.lwh
            
            tmObj.setSettingsArray()
            
            // FIXME: delete
            print (tmObj.settingsArray)
            
            tmObj.save()
            
            assert(tmObj.settingsArray.count == 2, "\n\n\nsave and load settingsArray from disc failed\n\n")
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindAndChangeDate(sender: UIStoryboardSegue) {
        if let cdvc = sender.sourceViewController as? ChangeDateViewController {
            tmObj.selectedDate = cdvc.newDate
            
            tmObj.save()
            
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Accountability Segue") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! AccountabilityTableViewController
            
            targetController.focusTasks = tmObj.focusTasksArr
        }
    }
    
}
