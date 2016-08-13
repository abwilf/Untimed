//
//  ChangeDateViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/16/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class ChangeDateViewController: UIViewController {
    
    var newDate = NSDate()
    

    @IBAction func changedDate(sender: UIDatePicker) {
        // min date = now        
        let currentDate = NSDate()
        sender.minimumDate = currentDate
        
        // max date = 28 - 1 days from now (where our cal array goes up to)
        let daysToAdd: Int = 28 - 1
        let futureDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
        sender.maximumDate = futureDate
        
        newDate = sender.date
        print (newDate)
       
        
    }
    
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
