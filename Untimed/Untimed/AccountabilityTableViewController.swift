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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
}
