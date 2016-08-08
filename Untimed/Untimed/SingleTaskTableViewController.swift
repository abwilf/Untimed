//
//  SingleTaskTableViewController.swift
//  Untimed
//
//  Created by Emily O'Connor on 4/4/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class SingleTaskTableViewController: UITableViewController {
    
    // FIXME: bug where if you don't go back to task list it won't save, because that's where the tmObject is.  NEED TO FIX!!
    var task = Task()
    var taskManagerObj = TaskManager()
    
    var index: Int = 0
    
    @IBOutlet weak var titleOneLabel: UILabel!
    @IBOutlet weak var detailOneLabel: UILabel!
    @IBOutlet weak var titleTwoLabel: UILabel!
    @IBOutlet weak var detailTwoLabel: UILabel!
    
    
    
    func updateTMObj () {
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let appointment = task as? Appointment {
            self.title = appointment.title

            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            
            //format date
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            //only gets date
            let strDate = dateFormatter.stringFromDate(appointment.startTime)
            
            //format time
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            //only gets time
            let strDateStartTime = timeFormatter.stringFromDate(appointment.startTime)
            let strDateEndTime = timeFormatter.stringFromDate(appointment.endTime)
            
            
            titleOneLabel.text  = "Starts"
            detailOneLabel.text = "\(strDate) at \(strDateStartTime)"
            
            titleTwoLabel.text = "Ends"
            detailTwoLabel.text = "\(strDate) at \(strDateEndTime)"
        }
            
        else if let assignment = task as? Assignment {
            
            self.title = assignment.title
            
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
            
            
            titleOneLabel.text = "Due On"
            detailOneLabel.text = "\(strDate) at \(strDueTime)"
            
            titleTwoLabel.text = "Time Remaining"
            detailTwoLabel.text = "\(Double(assignment.numBlocksNeeded) / 4.0)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let appointment = task as? Appointment {
            
            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            
            //format date
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            //only gets date
            let strDate = dateFormatter.stringFromDate(appointment.startTime)
            
            //format time
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            //only gets time
            let strDateStartTime = timeFormatter.stringFromDate(appointment.startTime)
            let strDateEndTime = timeFormatter.stringFromDate(appointment.endTime)
            
            
            titleOneLabel.text  = "Starts"
            detailOneLabel.text = "\(strDate) at \(strDateStartTime)"
            
            titleTwoLabel.text = "Ends"
            detailTwoLabel.text = "\(strDate) at \(strDateEndTime)"
        }
            
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
            
            
            titleOneLabel.text = "Due On"
            detailOneLabel.text = "\(strDate) at \(strDueTime)"
            
            titleTwoLabel.text = "Time Remaining"
            detailTwoLabel.text = "\(Double(assignment.numBlocksNeeded) / 4.0)"
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     // Configure the cell...
     return cell
     }
     */
    
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
    
    
//    @IBAction func unwindFromEditTask(sender: UIStoryboardSegue)
//    {
//        // editappt
//        if let easppttvc = sender.sourceViewController as? EditAppointmentTableViewController {
//            // pull in new task from editing page
//            task = easppttvc.appt
//            
//            // update taskManagerObj
//            taskManagerObj.tasks[index] = task
//            
//            // save taskManagerObj
//            taskManagerObj.save()
//        }
//        
//        
//        // editassn
//        if let eassntvc = sender.sourceViewController as? EditAssignmentTableViewController {
//            task = eassntvc.assn
//            taskManagerObj.tasks[index] = task
//            taskManagerObj.save()
//        }
//    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let _ = task as? Appointment {
            
            if (segue.identifier == "Edit Appointment") {
                    // single task view controller
                    if let eappttvc = segue.destinationViewController as? EditAppointmentTableViewController {
                        eappttvc.appt = task as! Appointment
                    }
            }
        }
            
        else if let _ = task as? Assignment {
            if (segue.identifier == "Edit Assignment") {
                if let eassntvc = segue.destinationViewController as? EditAssignmentTableViewController {
                    eassntvc.assn = task as! Assignment
                }
            }
        }
        
    }
}
