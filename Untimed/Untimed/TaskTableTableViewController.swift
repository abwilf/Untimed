//
//  TaskTableTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 3/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class TaskTableTableViewController: UITableViewController {
    
    let taskManager = TaskManager()

    func resetForTesting () {
        taskManager.classArray = []
        taskManager.save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskManager.loadFromDisc()
//        taskManager.createClassArray()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // FIXME: use only for testing
        // resetForTesting()

        super.viewWillAppear(animated)
        
//        taskManager.createClassArray()
//        taskManager.createProjOnlyArray()
        
        tableView.reloadData()
    }

    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let addTaskAction = UIAlertAction(title: "Assignment", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Assignment Segue", sender: TaskTableTableViewController())
        }
        let addAppointmentAction = UIAlertAction(title: "Appointment", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Appointment Segue", sender: TaskTableTableViewController())
        }
        let addProjectAction = UIAlertAction(title: "Project", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Project Segue", sender: TaskTableTableViewController())
        }
        let addProjectTaskAction = UIAlertAction(title: "Project Task", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Project Task Segue", sender: TaskTableTableViewController())
        }
        let addClassAction = UIAlertAction(title: "Class", style: .Default) { (action) in
            self.performSegueWithIdentifier("Add Class Segue", sender: TaskTableTableViewController())
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addTaskAction)
        alertController.addAction(addAppointmentAction)
        alertController.addAction(addProjectAction)
        alertController.addAction(addProjectTaskAction)
        alertController.addAction(addClassAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindAndAddTask(sender: UIStoryboardSegue)
    {
        // save from add assignment via unwind
        if let aavc =
            sender.sourceViewController as? AddAssignmentTableViewController {
            
            let classAddedAsgtBelongsTo = taskManager.classArray[aavc.addedAssignment.classTaskArrIndex]
            
            // add first to general tasks list, then erase and rederive classArray
            taskManager.addAssignment(aavc.addedAssignment, forClass: classAddedAsgtBelongsTo)
            
//            let tasksIndexForClass = taskManager.classArray[aavc.addedAssignment.classClassArrIndex].tasksIndex
            

//            if let tmt = taskManager.tasks[tasksIndexForClass] as? Class {
//                tmt.projAndAssns += [aavc.addedAssignment]
//            }
            
            // draws from tasks array in creation and saves
            taskManager.save()
            
            tableView.reloadData()
        }
        
        
        // save from add appointment
        if let aapptvc = sender.sourceViewController as? AddAppointmentTableViewController {
            taskManager.addAppointment(aapptvc.addedAppointment)
            taskManager.allocateAppts()
            taskManager.save()
            tableView.reloadData()
        }
        
        // add project
        if let aatvc = sender.sourceViewController as?
            AddProjectTableViewController {
            
            let classProjBelongsTo = taskManager.classArray[aatvc.addedProject.classClassArrIndex]
            
            taskManager.addProject(aatvc.addedProject, forClass: classProjBelongsTo)
        
            taskManager.save()
            
            tableView.reloadData()
        }
        
        // add project task
        if let apttvc = sender.sourceViewController as?
            AddProjectTaskTableViewController {

            let projectThatTaskBelongsTo = taskManager.classArray[apttvc.classIndex].projAndAssns[apttvc.projectAndAssnArrIndex] as! Project
            
                taskManager.addProjectTask(apttvc.addedProjTask, forProject: projectThatTaskBelongsTo)
            
            // works up to here.  doesn't save and load correctly (at least within this page)
            taskManager.save()
            
            tableView.reloadData()
        }
        
        // save from add class
        if let actvc = sender.sourceViewController as?
            AddClassTableViewController {
            
            taskManager.addClass(actvc.addedClass)
            
            taskManager.save()
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindAndDeleteTask(sender: UIStoryboardSegue) {
        if let sttvc =
            sender.sourceViewController as? SingleTaskTableViewController {
            let index = sttvc.index
//            taskManager.deleteTaskAtIndex(index)
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromTaskPages(sender: UIStoryboardSegue) {
        if let paatvc =
            sender.sourceViewController as? ProjectsAndAssignmentsTableViewController {
            taskManager.loadFromDisc()
            
            // recreate arrays
//            taskManager.createClassArray()
//            taskManager.createProjOnlyArray()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromSingleTaskViewer(sender: UIStoryboardSegue) {
        if let _ =
            sender.sourceViewController as? SingleTaskTableViewController {
            taskManager.loadFromDisc()
            tableView.reloadData()
        }
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
            return taskManager.classArray.count
            
        }
            
        else {
            return 0
        }
    }
    
    
    // indexpath is a location where the tableView is looking to put an object
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        // "Task Cell" is identifier of the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Task Cell",
                                                               forIndexPath: indexPath)
        
        if indexPath.row < taskManager.classArray.count {
            // Configure the cell
            let task = taskManager.classArray[indexPath.row]
            cell.textLabel?.text = task.title
             
           /*
 // assignment
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
                    "\(Double(assignment.numBlocksNeeded - assignment.numBlocksCompleted) / 4.0) hours remaining; Due \(strDate), at \(strDueTime)"
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
                        "Project: Target Completion Date: \(strDate)"
                }
                    
                else {
                    cell.detailTextLabel?.text = "Project"
                }
            }
                
 */

            cell.detailTextLabel?.text = ""
        }
        return cell
        
//        // This is where it splits into Appointment and Assignment
//        if let appointment = task as? Appointment {
//            
//            // assigning subtitle text to appropriate Appointment member
//            let dateFormatter = NSDateFormatter()
//            let timeFormatter = NSDateFormatter()
//            
//            // format date
//            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//            
//            // only gets date
//            let strDate = dateFormatter.stringFromDate(appointment.startTime)
//            
//            
//            // format time
//            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
//            
//            // only gets time
//            let strDateStartTime =
//                timeFormatter.stringFromDate(appointment.startTime)
//            let strDateEndTime = timeFormatter.stringFromDate(appointment.endTime)
//            
//            // print it
//            cell.detailTextLabel?.text =
//                "\(strDate) - \(strDateStartTime) to \(strDateEndTime)"
//        }
}
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let _ = taskManager.tasks[indexPath.row] as? Assignment {
//            performSegueWithIdentifier("Assignment View Segue", sender: TaskTableTableViewController())
//        }
//        if let _ = taskManager.tasks[indexPath.row] as? Appointment {
//            performSegueWithIdentifier("Appointment View Segue", sender: TaskTableTableViewController())
//        }
//    }
    
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
        
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        // if you click on a cell
//        if (segue.identifier == "Appointment View Segue") {
//            
//            // index = row number
//            if let index = tableView.indexPathForSelectedRow?.row {
//                // create object of task class and reference the object in the
//                // array at row location. remember that the row locations for
//                // the array and for the table will both be 0 indexed and will
//                // correspond perfectly (that's why we use the same numbers)
//                let task = taskManager.tasks[index]
//                
//             
//                
//                // dealing with Nav controller in between views
//                let destinationNavigationController = segue.destinationViewController as! UINavigationController
//                let targetController = destinationNavigationController.topViewController as! SingleTaskTableViewController
//                
//                targetController.task = task
//                targetController.taskManagerObj = taskManager
//                targetController.index = index
//                targetController.title = task.title
//            }
//        }
//        
//        if (segue.identifier == "Assignment View Segue") {
//            // index = row number
//            if let index = tableView.indexPathForSelectedRow?.row {
//                // create object of task class and reference the object in the
//                // array at row location. remember that the row locations for
//                // the array and for the table will both be 0 indexed and will
//                // correspond perfectly (that's why we use the same numbers)
//                let task = taskManager.tasks[index]
//                
//                // dealing with Nav controller in between views
//                let destinationNavigationController = segue.destinationViewController as! UINavigationController
//                let targetController = destinationNavigationController.topViewController as! SingleTaskTableViewController
//                
//                targetController.task = task
//                targetController.taskManagerObj = taskManager
//                targetController.index = index
//                targetController.title = task.title
//            }
//            
//        }
        
        // if click on add task button
        if (segue.identifier == "Add Assignment Segue") {
            
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            
            let targetController = destinationNavigationController.topViewController as! AddAssignmentTableViewController
            
            targetController.classes = taskManager.classArray
        }
        
        
        if (segue.identifier == "To Projects And Assignments") {
            
            let destinationNavController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavController.topViewController as! ProjectsAndAssignmentsTableViewController
            targetController.title = "Projects and Assignments"
            
            if let index = tableView.indexPathForSelectedRow?.row {
                // send projAndAssnArray to the next view controller based on which project is selected
                targetController.selectedClass = taskManager.classArray[index]
                
                targetController.tmObj = taskManager
            }
        }
        
        if (segue.identifier == "Add Project Segue") {
            
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
           
            let targetController = destinationNavigationController.topViewController as! AddProjectTableViewController

            targetController.classes = taskManager.classArray
        }
        
        if (segue.identifier == "Add Project Task Segue") {
            
            // update all class array elements with proj only arrays
            taskManager.createProjOnlyArray()
            
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! AddProjectTaskTableViewController
            targetController.classes = taskManager.classArray
        }
        
    }
    
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            taskManager.deleteClassAtIndex(classIndex: indexPath.row)
            
            taskManager.save()
            
            tableView.reloadData()
        }
    }
    
}