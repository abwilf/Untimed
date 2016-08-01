
//
//  AddAppointmentTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/5/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddAppointmentTableViewController: UITableViewController {
    
    // created task that we will modify
    var addedAppointment = Appointment()
    
    @IBOutlet weak var repeatDetail: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        repeatDetail?.text = addedAppointment.repeatOptionsArray[addedAppointment.repeatOptionsIndex]
        print(repeatDetail?.text)
    }
    

    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

    // did change start date
    
        // modifies end date minimum

    @IBAction func didChangeEditingAssignmentTitle(sender: UITextField) {
        // if able to unwrap, set it equal
        if let newTitle = sender.text {
            addedAppointment.title = newTitle
        }
    }
    
    
    // outlet modifying minimum end date so it can't be before start date
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var newStartDate = NSDate()

    // update start time
    @IBAction func didEnterStartDate(sender: UIDatePicker) {
        sender.minimumDate = NSDate()
        newStartDate = sender.date
        addedAppointment.startTime = newStartDate
        
        // update end date minimum to start date
        endDatePicker.minimumDate = newStartDate
        addedAppointment.endTime = endDatePicker.date
    }
    

    // update appointment's end time
    @IBAction func didEnterEndDate(sender: UIDatePicker) {
        addedAppointment.endTime = endDatePicker.date
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func textFieldDoneEditing(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  // took out num sections

  // took out num rows

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

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // send the classes array through to the pick a class view controller
        if (segue.identifier == "Repeat Segue") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            
            let targetController = destinationNavigationController.topViewController as! RepeatTableViewController
            
            targetController.optionIndex = addedAppointment.repeatOptionsIndex
        }
    }
    
    @IBAction func unwindAndUpdateRepeatOptionsIndex(sender: UIStoryboardSegue) {
        // save from add assignment via unwind
        if let rtvc =
            sender.sourceViewController as? RepeatTableViewController {
            // FIXME: optionIndex is 0 when it shouldn't be
            addedAppointment.repeatOptionsIndex = rtvc.optionIndex
            addedAppointment.repeatDaysIndex = rtvc.repeatDaysArr
            print(addedAppointment.repeatOptionsIndex)
        }
    }

    @IBAction func unwindAndUpdateCustomRepeatArray(sender: UIStoryboardSegue) {
        // save from add assignment via unwind
        if let crtvc =
            sender.sourceViewController as? CustomRepeatTableViewController {
            
            addedAppointment.repeatOptionsIndex = 4
            addedAppointment.repeatDaysIndex = crtvc.repeatDaysArray
        }
    }
}
