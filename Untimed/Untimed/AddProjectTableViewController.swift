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
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func didChangeProjectTitle(sender: UITextField) {
        if let newTitle = sender.text {
            addedProject.title = newTitle
        }
    }
    @IBAction func didEnterCompletionDate(sender: UIDatePicker) {
        let newDueDate = sender.date
        addedProject.completionDate = newDueDate
        sender.minimumDate = NSDate()
    }
    
}
