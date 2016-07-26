//
//  AddProjectTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/26/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddProjectTableViewController: UITableViewController {
    
    // var addedProject = Project()
    
    var projectTitle: String? = nil
    
    var completionDate: NSDate? = nil
    
    @IBAction func didChangeProjectTitle(sender: UITextField) {
        if let newTitle = sender.text {
            projectTitle = newTitle
        }
    }
    @IBAction func didEnterCompletionDate(sender: UIDatePicker) {
        let newDueDate = sender.date
        completionDate = newDueDate
        sender.minimumDate = NSDate()
    }
    
}
