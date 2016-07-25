//
//  AddAssignmentTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/6/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddAssignmentTableViewController: UITableViewController {
    
    var addedAssignment = Assignment()
    
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // assn title
    @IBAction func didChangeEditingAssignmentTitle(sender: UITextField) {
        if let newTitle = sender.text {
            addedAssignment.title = newTitle
        }
    }
    
    
    @IBAction func didEnterDueDate(sender: UIDatePicker) {
        var newDueDate = NSDate()
        newDueDate = sender.date
        addedAssignment.dueDate = newDueDate
        sender.minimumDate = NSDate()
    }
    
    @IBOutlet weak var switchLabel: UILabel!
    
    @IBAction func addButtonPressed(sender: UIStepper) {
        addedAssignment.numBlocksNeeded = Int(sender.value * 4)
        switchLabel.text = "\(String(sender.value)) hours"
    }
    
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            addedAssignment.priorityValue = 1;
        case 1:
            addedAssignment.priorityValue = 2;
        case 2:
            addedAssignment.priorityValue = 3;
        default:
            break;
        }
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
    
}
