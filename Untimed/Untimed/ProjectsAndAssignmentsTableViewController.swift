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
    var selectedClass = Class()
    var indexChosen: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                "\(Double(assignment.numBlocksNeeded - assignment.numBlocksCompleted) / 4.0) hours remaining; Due \(strDate), at \(strDueTime)."
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
    
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
                // delete it from the projAndAssnArray
                selectedClass.deleteElementFromProjAndAssns(indexPath.row)
                
                // update all .tasksIndex values to reflect change in tasks
                selectedClass.updateProjAndAssnIndexValues()
        }
            tableView.reloadData()

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
            
            let destinationViewController = segue.destinationViewController as! ProjTasksTableViewController
            
            if let proj = selectedClass.projAndAssns[indexChosen] as? Project {
                destinationViewController.projTasksArr = proj.projTaskArr
                
                // set title
                destinationViewController.title = "Tasks for \(proj.title)"
            }
        }
        
        
    }
}
    

