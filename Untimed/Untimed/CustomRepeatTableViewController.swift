//
//  CustomRepeatTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/22/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class CustomRepeatTableViewController: AddAppointmentTableViewController {
    
    var repeatDaysArray = [Bool](count: 7, repeatedValue: false)

    @IBAction func savePressedCustom(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("unwindToAddAppointment", sender: self)
    }
    
    @IBAction func cancelPressedCustom(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            if cell.accessoryType == UITableViewCellAccessoryType.None {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                repeatDaysArray[indexPath.row] = true
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
                repeatDaysArray[indexPath.row] = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if tableView.indexPathForSelectedRow?.section == 0 {
//            if let indexChosen = tableView.indexPathForSelectedRow?.row {
//                // send projAndAssnArray to the next view controller based on which project is selected
//                optionIndex = indexChosen
//            }
//        }
//        else if tableView.indexPathForSelectedRow?.section == 1 {
//            optionIndex = 5
//        }
//    }
}
