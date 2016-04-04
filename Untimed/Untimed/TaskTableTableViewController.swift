//
//  TaskTableTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 3/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class TaskTableTableViewController: UITableViewController {
    
    // Creates object of TaskManager class and initializes tasks array
    @IBOutlet var tableTasks : UITableView!
    let taskManager = TaskManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        tableTasks.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // warning Incomplete implementation, return the number of sections.  This is like the contacts app, where there are 26 sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // warning Incomplete implementation, return the number of rows
        
        // don't get thrown off by the "numberofRowsInSection" phrase.  "section" refers to the index number (like how arrays start counting at 0).  Since we only have 1 section, we're saying that if section = 0, we're in section 1, which is the only one, and we should return the number of rows we want in that section (in this case it's all of them)
        if section == 0 {
            // return number of rows we want in this section (all) - count is a built in function to return the number of elements in an array
            return taskManager.tasks.count
        }
        
        else {
            return 0
        }
    }
    
    
    
    // indexpath is a location where the tableView is looking to put an object. indexpath has rows and sections, so you need to specify with dot operator.
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        // not loading 10,000 cells on ipod at once.  "Task Cell" is identifier of the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Task Cell", forIndexPath: indexPath)

        // declare task object, and have it take the value of the array at the row specified by indexpath
        let task = taskManager.tasks[indexPath.row]
        
        
        // Configure the cell.  For both types of task, the title will just be task.title because the superclass has .title as a member variable.  If not a nil label, assign task title to it (if cell exists and is specified by indexpath.
        cell.textLabel?.text = task.title
        
       
        // This is where it splits into Appointment and Assignment. if task is an appt, list different details as the subtitle (detailTextLabel).  We test this by creating some variable (appointment) as a kind of thought experiment, setting it equal to the task object, and asking if that new variable, appointment, can be casted as an Appointment object, thereby asking if task is an Appointment object or not
       
        if let appointment = task as? Appointment {
            
            // assigning subtitle text to appropriate Appointment member variables (startTime and endTime)
            // test: cell.detailTextLabel?.text = "3 pm"
            cell.detailTextLabel?.text = "Starts \(appointment.startTime), ends \(appointment.endTime)"

        }
            
        // if not, task must be an Assignment.  show different subtitles
        else if let assignment = task as? Assignment {
            
            // set subtitle to member variables of the assignment object
            cell.detailTextLabel?.text = "Due on \(assignment.dueDate), \(assignment.timeNeeded) hours needed"
        }
        
       return cell
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "Select Task") {
            
            // index = row number
            if let index = tableView.indexPathForSelectedRow?.row {
                // create object of task class and reference the object in the array at row location. remember that the row locations for the array and for the table will both be 0 indexed and will correspond perfectly (that's why we use the same numbers)
                let task = taskManager.tasks[index]

                // set the title of the view we're going to as that object's title
                segue.destinationViewController.title = task.title
            
                // single task view controller
                if let stvc = segue.destinationViewController as? SingleTaskViewController {
                    stvc.task = task
                }
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            taskManager.tasks.removeAtIndex(indexPath.row)
            tableTasks.reloadData()
        }
    }


}
