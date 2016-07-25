//
//  EditAssignmentTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/13/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class EditAssignmentTableViewController: UITableViewController {
    
    var assn = Assignment()

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func editedAssnTitle(sender: UITextField) {
        if let newTitle = sender.text {
            assn.title = newTitle
        }
    }
    
   
    @IBAction func doneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBOutlet weak var switchLabel: UILabel!
    
    @IBAction func switchButtonPressed(sender: UIStepper) {
        assn.numBlocksNeeded = Int(sender.value * 4)
        switchLabel.text = "\(String(sender.value)) hours"
    }
   
    @IBAction func editedDueDate(sender: UIDatePicker) {
        assn.dueDate = sender.date
        sender.minimumDate = NSDate()
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            assn.priorityValue = 1;
        case 1:
            assn.priorityValue = 2;
        case 2:
            assn.priorityValue = 3;
        default:
            break;
        }
    }

}
