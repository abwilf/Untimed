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

    @IBOutlet weak var titleOneLabel: UILabel!
    @IBOutlet weak var detailOneLabel: UILabel!
    @IBOutlet weak var titleTwoLabel: UILabel!
    @IBOutlet weak var detailTwoLabel: UILabel!
    
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
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            //only gets date
            let strDate = dateFormatter.stringFromDate(appointment.startTime)
            
            //format time
            timeFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            
            //only gets time
            let strDateStartTime = timeFormatter.stringFromDate(appointment.startTime)
            let strDateEndTime = timeFormatter.stringFromDate(appointment.endTime)
            
            
            titleOneLabel.text  = "Starts"
            detailOneLabel.text = "\(strDate) - \(strDateStartTime)"
            
            titleTwoLabel.text = "Ends"
            detailTwoLabel.text = "\(strDate) - \(strDateEndTime)"
        }
        
        else if let assignment = task as? Assignment {
            
            
            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            
            //format date
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            //only gets date
            let strDate = dateFormatter.stringFromDate(assignment.dueDate)
            
            //format time
            timeFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            
            //only gets time
            let strDueDate = timeFormatter.stringFromDate(assignment.dueDate)
        

            
            
            titleOneLabel.text = "Due On"
            detailOneLabel.text = "\(strDate) - \(strDueDate)"
            
            titleTwoLabel.text = "Time Needed"
            detailTwoLabel.text = "\(assignment.timeNeeded) hours"
        }
    }
        
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
