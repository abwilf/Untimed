//
//  EditAppointmentTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/13/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class EditAppointmentTableViewController: UITableViewController {
    var appt = Appointment()

   
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func didStartEditing(sender: UITextField) {
        if let newTitle = sender.text {
            appt.title = newTitle
        }
    }
    
    
    @IBAction func editingDidEnd(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func enteredStartDate(sender: UIDatePicker) {
        appt.startTime = sender.date
        sender.minimumDate = NSDate()
    }
    
    @IBAction func enteredEndDate(sender: UIDatePicker) {
        appt.endTime = sender.date
        sender.minimumDate = NSDate()
    }
    
}