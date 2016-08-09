//
//  AddProjectTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/26/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddProjectTableViewController: UITableViewController {
    
    var addedProject = Project()
    var classes: [Class] = []
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func editingDidChange(sender: UITextField) {
        if let newTitle = sender.text {
            addedProject.title = newTitle
        }
    }
    
    @IBAction func editingDidEnd(sender: UITextField) {
        sender.resignFirstResponder()
    }

    @IBAction func didEnterCompletionDate(sender: UIDatePicker) {
        let newDueDate = sender.date
        addedProject.completionDate = newDueDate
        sender.minimumDate = NSDate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // send the classes array through to the pick a class view controller
        if (segue.identifier == "Pick A Class") {
            let destinationViewController = segue.destinationViewController as! PickAClassTableViewController
            destinationViewController.classArr = classes
        }
    }
    
    @IBAction func unwindFromPickAClass(sender: UIStoryboardSegue) {
        if let pactvc =
            sender.sourceViewController as? PickAClassTableViewController {
            addedProject.classClassArrIndex = pactvc.index
        }
    }
    
}
