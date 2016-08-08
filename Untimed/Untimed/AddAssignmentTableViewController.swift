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
    var classes: [Class] = []
    var index: Int = 0

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // send the classes array through to the pick a class view controller
        if (segue.identifier == "Find a Class") {
            let destinationViewController = segue.destinationViewController as! PickAClassTableViewController
            destinationViewController.classArr = classes
        }
    }
    
    @IBAction func unwindFromPickAClass(sender: UIStoryboardSegue) {
        if let pactvc =
            sender.sourceViewController as? PickAClassTableViewController {
            addedAssignment.classClassArrIndex = pactvc.index
        }
    }
    
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
    
    
    var priorityValue = 1
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            priorityValue = 1;
        case 1:
            priorityValue = 2;
        case 2:
            priorityValue = 3;
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
