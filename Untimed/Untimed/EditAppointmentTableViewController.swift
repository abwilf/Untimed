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

   
    @IBAction func didEditTitle(sender: UITextField) {
        if let newTitle = sender.text {
            appt.title = newTitle
        }
    }
    
    
    @IBAction func didEnterStartTime(sender: UIDatePicker) {
        var newStartDate = NSDate()
        newStartDate = sender.date
        appt.startTime = newStartDate
    }
    
    
    @IBAction func didEnterEndTime(sender: UIDatePicker) {
        var newEndDate = NSDate()
        newEndDate = sender.date
        appt.endTime = newEndDate
    }
    
    
}