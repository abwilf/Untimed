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

    
    @IBAction func didEditAssnTitle(sender: UITextField) {
        if let newTitle = sender.text {
            assn.title = newTitle
        }
    }
    
    
    @IBAction func didEditDueDate(sender: UIDatePicker) {
        var newDueDate = NSDate()
        newDueDate = sender.date
        assn.dueDate = newDueDate
    }
    
    // need changedTime action!!!
}
