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
        newDate = sender.date
    }
    
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
