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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
