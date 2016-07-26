//
//  TaskTableTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 3/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class TaskTableTableViewController: UITableViewController {
    
    // setting variable to know what index to edit if that happens
    // FIXME: DELETE var indexVar = 0
    
    // Creates object of TaskManager class and initializes tasks array
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let addTaskAction = UIAlertAction(title: "Add Assignment", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Assignment Segue", sender: TaskTableTableViewController())
        }
        let addAppointmentAction = UIAlertAction(title: "Add Appointment", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Appointment Segue", sender: TaskTableTableViewController())
        }
        let addProjectAction = UIAlertAction(title: "Add Project", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Project Segue", sender: TaskTableTableViewController())
        }
        let addClassAction = UIAlertAction(title: "Add Class", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Class Segue", sender: TaskTableTableViewController())
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addTaskAction)
        alertController.addAction(addAppointmentAction)
//        alertController.addAction(addProjectAction)
//        alertController.addAction(addClassAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    let taskManager = TaskManager()
    
    @IBAction func reloadPressed(sender: UIBarButtonItem) {
        taskManager.loadFromDisc()
    }
    
    // unwind segues
    
    
    @IBAction func unwindAndAddTask(sender: UIStoryboardSegue)
    {
        // add assignment created
        if let aavc =
            sender.sourceViewController as? AddAssignmentTableViewController {
            taskManager.addTask(aavc.addedAssignment)
            
            tableView.reloadData()
        }
        
        
        // add appointment created
        if let aapptvc = sender.sourceViewController as?
            AddAppointmentTableViewController {
            taskManager.addTask(aapptvc.addedAppointment)
            
            tableView.reloadData()
        }
        
        // Pull any data from the view controller which initiated the unwind segue.
    }
    
    @IBAction func unwindAndDeleteTask(sender: UIStoryboardSegue) {
        if let sttvc =
            sender.sourceViewController as? SingleTaskTableViewController {
            let index = sttvc.index
            taskManager.deleteTaskAtIndex(index)
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromSingleTaskViewer(sender: UIStoryboardSegue) {
        if let sttvc =
            sender.sourceViewController as? SingleTaskTableViewController {
            taskManager.loadFromDisc()
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        //return the number of rows we want in that section
        if section == 0 {
            // return number of rows we want in this section (all tasks)
            return taskManager.tasks.count
            
        }
            
        else {
            return 0
        }
    }
    
    
    
    // indexpath is a location where the tableView is looking to put an object
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        // not loading 10,000 cells on ipod at once.  "Task Cell" is identifier
        // of the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Task Cell",
                                                               forIndexPath: indexPath)
        
        // declare task object, and have it take the value of the array at the
        // row specified by indexpath
        let task = taskManager.tasks[indexPath.row]
        
        
        // Configure the cell
        cell.textLabel?.text = task.title
        
        
        // This is where it splits into Appointment and Assignment
        if let appointment = task as? Appointment {
            
            // assigning subtitle text to appropriate Appointment member
            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            
            // format date
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            
            // only gets date
            let strDate = dateFormatter.stringFromDate(appointment.startTime)
            
            
            // format time
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            // only gets time
            let strDateStartTime =
                timeFormatter.stringFromDate(appointment.startTime)
            let strDateEndTime = timeFormatter.stringFromDate(appointment.endTime)
            
            // print it
            cell.detailTextLabel?.text =
                "\(strDate) - \(strDateStartTime) to \(strDateEndTime)"
        }
            
            // if not, task must be an Assignment.  show different subtitles
        else if let assignment = task as? Assignment {
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
                "\(Double(assignment.numBlocksNeeded - assignment.numBlocksCompleted) / 4.0) hours remaining; Due \(strDate), at \(strDueTime)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = taskManager.tasks[indexPath.row] as? Assignment {
            performSegueWithIdentifier("Assignment View Segue", sender: TaskTableTableViewController())
        }
        if let _ = taskManager.tasks[indexPath.row] as? Appointment {
            performSegueWithIdentifier("Appointment View Segue", sender: TaskTableTableViewController())
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath
     //indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle
     // editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath
     // indexPath: NSIndexPath) { if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array,
     // and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath
     fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath
     indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // if you click on a cell
        if (segue.identifier == "Appointment View Segue") {
            
            // index = row number
            if let index = tableView.indexPathForSelectedRow?.row {
                // create object of task class and reference the object in the
                // array at row location. remember that the row locations for
                // the array and for the table will both be 0 indexed and will
                // correspond perfectly (that's why we use the same numbers)
                let task = taskManager.tasks[index]
                
             
                
                // dealing with Nav controller in between views
                let destinationNavigationController = segue.destinationViewController as! UINavigationController
                let targetController = destinationNavigationController.topViewController as! SingleTaskTableViewController
                
                targetController.task = task
                targetController.taskManagerObj = taskManager
                targetController.index = index
                targetController.title = task.title
            }
        }
        
        if (segue.identifier == "Assignment View Segue") {
            // index = row number
            if let index = tableView.indexPathForSelectedRow?.row {
                // create object of task class and reference the object in the
                // array at row location. remember that the row locations for
                // the array and for the table will both be 0 indexed and will
                // correspond perfectly (that's why we use the same numbers)
                let task = taskManager.tasks[index]
                
                //               FIXME: DELETE indexVar = index
                
                // dealing with Nav controller in between views
                let destinationNavigationController = segue.destinationViewController as! UINavigationController
                let targetController = destinationNavigationController.topViewController as! SingleTaskTableViewController
                
                targetController.task = task
                targetController.taskManagerObj = taskManager
                targetController.index = index
                targetController.title = task.title
            }
        }
        
        
        // if click on add task button
        if (segue.identifier == "Add Task") {
            segue.destinationViewController.title = "Add Task"
        }
        
    }
    
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            taskManager.deleteTaskAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
}