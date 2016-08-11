//
//  ProjectsAndAssignmentsTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 7/27/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class ProjectsAndAssignmentsTableViewController: UITableViewController {

    // assns and projects for this class stored here
    var tmObj = TaskManager()
    var selectedClass = Class()
    var classArrOrigIndex = 0
    var indexChosen: Int = 0
    
    var focusIndicator: Bool = false
    
    // index in the cal array of the working block you're attaching the focus to
    var wbIndex: Int = 0
    var dateLocationDay: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let addTaskAction = UIAlertAction(title: "Assignment", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Assignment Segue", sender: TaskTableTableViewController())
        }
        
        let addProjectAction = UIAlertAction(title: "Project", style: .Default) { (action) in
        self.performSegueWithIdentifier("Add Project Segue", sender: TaskTableTableViewController())
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(addTaskAction)
        alertController.addAction(addProjectAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedClass.projAndAssns.count
    }
 

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PandA Cell", forIndexPath: indexPath)
        
        let task = selectedClass.projAndAssns[indexPath.row]
        cell.textLabel?.text = selectedClass.projAndAssns[indexPath.row].title

        // format assignment cells
        if let assignment = task as? Assignment {
            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            
            //format date
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            //only gets date
            let strDate = dateFormatter.stringFromDate(assignment.dueDate)
            
            //format time
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            //only gets time
            let strDueTime = timeFormatter.stringFromDate(assignment.dueDate)
            
            // set subtitle to member variables of the assignment object
            cell.detailTextLabel?.text =
                "\(Double(assignment.timeNeeded)) hours remaining; Due \(strDate), at \(strDueTime)."
        }
            
        // project
        else if let project = task as? Project {
            let dateFormatter = NSDateFormatter()
            
            //format date
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            if let compDate = project.completionDate {
                //only gets date
                let strDate = dateFormatter.stringFromDate(compDate)
                
                // set subtitle to member variables of the assignment object
                cell.detailTextLabel?.text =
                    "Target Completion Date: \(strDate)."
            }
                
            else {
                cell.detailTextLabel?.text = "Project"
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        // if we're in focus, not view mode
        if focusIndicator == true {
            if let indexSelected = tableView.indexPathForSelectedRow?.row {
                // if it's an assignment
                if let assnObj = selectedClass.projAndAssns[indexSelected] as? Assignment {
                    
                    // add check mark
                    let numberOfRows = selectedClass.projAndAssns.count
                    for row in 0..<numberOfRows {
                        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) {
                            cell.accessoryType = row == indexPath.row ? .Checkmark : .None
                        }
                    }
                    
                    // add object to focus array
                    tmObj.focusTasksArr += [assnObj]
                    
                    // modify working block
                    if let wb = tmObj.calendarArray[dateLocationDay][wbIndex] as? WorkingBlock {
                        wb.focusArr += [assnObj]
                    }
                }
                
                // else if project segue away
                else {
                    performSegueWithIdentifier("To Project Task Focus", sender: self)
                }
            }
        }
        
        // in view mode
        else {
            if let indexSelected = tableView.indexPathForSelectedRow?.row {
                // if it's an assignment
                if let assnObj = selectedClass.projAndAssns[indexSelected] as? Assignment {
                    // FIXME: segue to single task viewer
                }
                    
                // if project use project task segue
                else {
                    performSegueWithIdentifier("Show Proj Tasks", sender: self)
                }
            }
        }
    }
    
    // FIXME: consider combining tmObj.deleteProjectAtIndex and .deleteAssignmentAtIndex
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            tmObj.deleteProjectOrAssignmentAtIndex(index: indexPath.row, forClass: selectedClass)
                
            tmObj.save()
            
            tableView.reloadData()

        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Proj Tasks" {
            
            if let indexSelected = tableView.indexPathForSelectedRow?.row {
                indexChosen = indexSelected
            }
            
            
            let destinationNavController = segue.destinationViewController as! UINavigationController
            
            let topViewController = destinationNavController.topViewController as! ProjTasksTableViewController
            
            if let proj = selectedClass.projAndAssns[indexChosen] as? Project {
               
                // pass in tmObj carrying taskslist
                topViewController.tmObj = tmObj
                
                // pass in info for Project
                topViewController.selectedProject = proj
                topViewController.parentProjectPAndAArrIndex = indexChosen
//                topViewController.parentProjectTaskIndex = tmObj.findTasksIndexForTask(proj)
                
                // pass in locators for Class
//                topViewController.classIndexInTasks = tmObj.findTasksIndexForTask(selectedClass)
                
                // set title
                topViewController.title = "Tasks for \(proj.title)"
            }
        }
        
        if segue.identifier == "To Project Task Focus" {
            
            let destinationNavController = segue.destinationViewController as! UINavigationController
            
            let topViewController = destinationNavController.topViewController as! ProjTasksTableViewController
            
            // find Project picked
            if let indexSelected = tableView.indexPathForSelectedRow?.row {
                indexChosen = indexSelected
            }
            
            if let proj = selectedClass.projAndAssns[indexChosen] as? Project {
                
                // pass in tmObj carrying taskslist
                topViewController.tmObj = tmObj
                
                // pass in info for Project
                topViewController.selectedProject = proj
                topViewController.parentProjectPAndAArrIndex = indexChosen
                
                // set working block index
                topViewController.wbIndex = wbIndex
                topViewController.dateLocationDay = dateLocationDay
                
                // focus, not view mode
                topViewController.focusIndicator = focusIndicator
                
                topViewController.title = "Tasks for \(proj.title)"
            }
        }
    }
    
    @IBAction func unwindFromPT (sender: UIStoryboardSegue) {
        if let _ =
            sender.sourceViewController as? ProjTasksTableViewController {
            tmObj.loadFromDisc()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromPTFocus (sender: UIStoryboardSegue) {
        if let pttvc =
            sender.sourceViewController as? ProjTasksTableViewController {
            tmObj = pttvc.tmObj
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromAddProj (sender: UIStoryboardSegue) {
        if let aptvc =
            sender.sourceViewController as? AddProjectTableViewController {
            
            selectedClass.projAndAssns += [aptvc.addedProject]
            
            tableView.reloadData()
        }
    }

}
    

