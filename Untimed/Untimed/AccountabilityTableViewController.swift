//
//  AccountabilityTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/9/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AccountabilityTableViewController: UITableViewController {
    var focusTasks: [Task] = []
    var indexSelected: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let index = tableView.indexPathForSelectedRow?.row {
            indexSelected = index
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return focusTasks.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Accountability Cell", forIndexPath: indexPath)

        let task = focusTasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        // Configure the cell...

        return cell
    }
    
    @IBAction func unwindAndModifyHoursCompleted(sender: UIStoryboardSegue)
    {
        if let tcvc = sender.sourceViewController as? TimeCompletedViewController {
            // find object in focusArray using indexSelected
            let objectToModify = focusTasks[indexSelected]
            
            // modify hours completed 
            if let temp = objectToModify as? Assignment {
                temp.timeNeeded -= tcvc.hoursCompleted
                
                if temp.timeNeeded < 0 {
                    temp.timeNeeded = 0
                }
            }
            
            if let temp = objectToModify as? ProjectTask {
                temp.timeNeeded -= tcvc.hoursCompleted
                
                if temp.timeNeeded < 0 {
                    temp.timeNeeded = 0
                }
            }
        }
    }

}
