//
//  RepeatTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/22/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class RepeatTableViewController: UITableViewController {
    
    var optionIndex: Int = 0
    
    var repeatDaysArr = [Bool](count: 7, repeatedValue: false)
    
    var currentCategory: NSIndexPath? = nil
    var taskCategories: NSArray? = nil
    
    //var appointment = Appointment()
    
    override func viewDidAppear(animated: Bool) {
        
//        super.viewWillAppear(animated)
        
        var initialIndexPath = NSIndexPath(forRow: optionIndex, inSection: 0)
        if optionIndex < 5 {
        }
        else {
            initialIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        }
        let initialCell = tableView.cellForRowAtIndexPath(initialIndexPath)
        initialCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if tableView.indexPathForSelectedRow?.section == 0 {
            if let indexChosen = tableView.indexPathForSelectedRow?.row {
                // send projAndAssnArray to the next view controller based on which project is selected
                optionIndex = indexChosen
            }
        }
        else if tableView.indexPathForSelectedRow?.section == 1 {
            optionIndex = 4
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            optionIndex = indexPath.row
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}