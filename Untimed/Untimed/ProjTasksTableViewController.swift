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
    
    // locators for PT
    var indexInPTArray = 0
    
    // locators for Project
    var parentProjectTaskIndex = 0
    var parentProjectPAndAArrIndex = 0
    
    // locators for Class
    var classIndexInTasks = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        setprojTasksArr()
    }

//    func setprojTasksArr() {
//        projTasksArr = selectedProject.projTaskArr
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProject.projTaskArr.count
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
