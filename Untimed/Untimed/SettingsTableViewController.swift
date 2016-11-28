//
//  SettingsTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 7/26/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var fwh = NSDate(dateString: "08:00")
    var lwh = NSDate(dateString: "19:00")
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func changeWorkingDayStart(sender: UIDatePicker) {
        fwh = sender.date
    }
    
    @IBAction func changedWorkingDayEnd(sender: UIDatePicker) {
        lwh = sender.date
    }
    
}
