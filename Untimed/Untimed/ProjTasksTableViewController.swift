//
//  ProjTasksTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/2/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class ProjTasksTableViewController: UITableViewController {
//    var projTasksArr: [ProjectTask] = []
    var selectedProject = Project()

    
    var tmObj = TaskManager()
    
    var checked: [Bool]? = nil
    
    // locators for PT
    var indexInPTArray = 0
    
    // locators for Project
    var parentProjectTaskIndex = 0
    var parentProjectPAndAArrIndex = 0
    
    // locators for Class
    var classIndexInTasks = 0
    
    var focusIndicator: Bool = false
    
    // index in the cal array of the working block you're attaching the focus to
    var wbIndex: Int = 0
    var dateLocationDay: Int = 0

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProject.projTaskArr.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // if we're in focus mode
        if focusIndicator == true {
            if checked == nil {
                checked = Array(count: selectedProject.projTaskArr.count, repeatedValue: false)
            }
            
//                let addedPT = selectedProject.projTaskArr[indexSelected]
                
                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row,
                                                                          inSection: 0)) {
                    if cell.accessoryType == .Checkmark {
                        cell.accessoryType = .None
                        checked![indexPath.row] = false
                    }
                    else {
                        cell.accessoryType = .Checkmark
                        checked![indexPath.row] = true
                    }
                }
                
//                // add check mark
//                let numberOfRows = selectedProject.projTaskArr.count
//                for row in 0..<numberOfRows {
//                    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) {
//                        if cell.accessoryType == .Checkmark {
//                            cell.accessoryType = .None
//                            checked[indexPath.row] = false
//                        } else {
//                            cell.accessoryType = .Checkmark
//                            checked[indexPath.row] = true
//                        }
//                    }
//                }
                
//                // add object to focus array
//                tmObj.focusTasksArr += [addedPT]
//                
//                // modify working block
//                if let wb = tmObj.calendarArray[dateLocationDay][wbIndex] as? WorkingBlock {
//                    wb.focusArr += [addedPT]
//                }
        }
            
        // in view mode
        else {
            
        }
    }
    
    func updateFocusTasks() {
        if checked != nil {
            for ptIndex in 0..<checked!.count {
                if checked![ptIndex] {
                    tmObj.focusTasksArr += [selectedProject.projTaskArr[ptIndex]]
                    if let wb = tmObj.calendarArray[dateLocationDay][wbIndex] as? WorkingBlock {
                        wb.focusArr += [selectedProject.projTaskArr[ptIndex]]
                    }
                }
            }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Proj Task Cell", forIndexPath: indexPath)
    
        let projTaskObj = selectedProject.projTaskArr[indexPath.row]
        
        cell.textLabel?.text = projTaskObj.title
        
        let dateFormatter = NSDateFormatter()
        
        //format date
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        //only gets date
        let strDate = dateFormatter.stringFromDate(projTaskObj.dueDate)
        
        // set subtitle to member variables of the assignment object
        cell.detailTextLabel?.text =
            "\(Double(projTaskObj.numBlocksNeeded) / 4.0) hours remaining; Due \(strDate)."
        
        return cell
    }
 
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            tmObj.deleteProjectTaskAtIndex(projTaskIndex: indexPath.row, forProj: selectedProject)
            
            // save tmObj to disc
            tmObj.save()
            
            tableView.reloadData()
        }
    }

    

}
