//
//  ProjTasksTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/2/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class ProjTasksTableViewController: UITableViewController {
    var projTasksArr: [ProjectTask] = []
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
        
        setprojTasksArr()
    }

    func setprojTasksArr() {
        projTasksArr = selectedProject.projTaskArr
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projTasksArr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Proj Task Cell", forIndexPath: indexPath)
    
        let projTaskObj = projTasksArr[indexPath.row]
        
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
 

    // FIXME: impelement delete
//    override func tableView(tableView: UITableView,
//                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
//                                               forRowAtIndexPath indexPath: NSIndexPath){
//        if (editingStyle == UITableViewCellEditingStyle.Delete){
//            var removedFromProjTasks = false
//            
//            // find object's tasks index
//            let tasksIndex = tmObj.findTasksIndexForTask(selectedProject.projTaskArr[indexPath.row])
//            
//            // modify the project it's a part of
//            if let task = tmObj.tasks[tasksIndex] as? ProjectTask {
//                // find the project in the tasks array
//                let tasksIndexForProject = task.projInTaskArrIndex
//                
//                // FIXME: this isn't evaluating to true
//                // delete the task from that project's projTask array (for the project in tasks)
//                if let proj = tmObj.tasks[tasksIndexForProject] as? Project {
//                    
//                    // find PT index in projAndAssnArray
//                    let ptIndex = tmObj.findProjTaskIndexInProj(tasksIndexForProject, taskIn: task)
//                    
//                    // delete it from the project's PT arr
//                    proj.deleteElementFromProjTaskArr(ptIndex)
//                    
//                    removedFromProjTasks = true
//                    
//                    // modify the class that the project's a part of (in tasks) by replacing its project version with this one: first find class index in tasks
//                    let classTaskIndex = proj.classTaskArrIndex
//                    
//                    // find project index within class' projAndAssnarray
//                    let projIndexInClassArr = tmObj.findProjAndAssnIndex(classTaskIndex, taskIn: proj)
//                    
//                    // replace project in class with modified one from tasks
//                    if let clas = tmObj.tasks[classTaskIndex] as? Class {
//                        clas.projAndAssns[projIndexInClassArr] = proj
//                    }
//                    
//                    // modify selectedProject for printing
//                    selectedProject = proj
//                    
//                    // FIXME: TESTING
//                    print ("Project Name: \(tmObj.tasks[tasksIndexForProject]) \n PT Name: \(tmObj.tasks[tasksIndex]) \n Class Name: \(tmObj.tasks[classTaskIndex])")
//                    
//                    
//                }
//            }
//            
//            assert(removedFromProjTasks, "ProjectTask not removed from ProjTaskArray")
//            
//            // delete PT at that index in tasks
//            tmObj.tasks.removeAtIndex(tasksIndex)
//            
//            // update .tasksIndex values
//            tmObj.updateTaskIndexValues()
//            
//            // recreate array from modified tasks
//            tmObj.createClassArray()
//            
//            // save tmObj to disc
//            tmObj.save()
//            
//        }
//        tableView.reloadData()
//        
//    }


}
