//
//  SingleTaskTableViewController.swift
//  Untimed
//
//  Created by Emily O'Connor on 4/4/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class SingleTaskTableViewController: UITableViewController {
    
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
            detailTwoLabel.text = "\(Double(assignment.timeNeeded))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            detailTwoLabel.text = "\(Double(assignment.timeNeeded))"
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
