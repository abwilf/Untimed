//
//  AccountabilityTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/9/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

// FIXME: include a button to check off tasks that you haven't specified as a focus
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

        if let task = focusTasks[indexPath.row] as? ProjectTask {
            cell.textLabel?.text = task.title
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            let strDate = dateFormatter.stringFromDate(task.dueDate)
            
            cell.detailTextLabel?.text = "\(Double(task.timeNeeded)) hours remaining; Due \(strDate)."
        }
        else if let task = focusTasks[indexPath.row] as? Assignment {
            cell.textLabel?.text = task.title
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            let strDate = dateFormatter.stringFromDate(task.dueDate)
            
            cell.detailTextLabel?.text = "\(Double(task.timeNeeded)) hours remaining; Due \(strDate)."
        }

        return cell
            
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Time Completed Segue" {
            if let targetController = segue.destinationViewController as? TimeCompletedViewController {
                targetController.task = focusTasks[indexSelected]
            }
        }
    }
    
    @IBAction func unwindAndModifyHoursCompleted(sender: UIStoryboardSegue)
    {
        if let tcvc = sender.sourceViewController as? TimeCompletedViewController {
            
            // find object in focusArray using indexSelected
//            let objectToModify = focusTasks[indexSelected]
            let objectToModify = tcvc.task
            
            // modify hours completed 
            if let temp = objectToModify as? Assignment {
                temp.timeNeeded -= tcvc.hoursCompleted
                
                if temp.timeNeeded < 0 {
                    temp.timeNeeded = 0
                }
            }
            
            else if let temp = objectToModify as? ProjectTask {
                temp.timeNeeded -= tcvc.hoursCompleted
                
                if temp.timeNeeded < 0 {
                    temp.timeNeeded = 0
                }
            }
        }
        tableView.reloadData()
    }

}
