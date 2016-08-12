//
//  SettingsTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 7/26/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // first and last working minutes
//    var fwm = 480
//    var lwm = 1140
    var fwh = NSDate(dateString: "08:00")
    var lwh = NSDate(dateString: "23:00")
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func changeWorkingDayStart(sender: UIDatePicker) {
        fwh = sender.date
//        fwm = nsTimeInDSCalFormat(sender.date)
       // sender.maximumDate =
    }
    
    @IBAction func changedWorkingDayEnd(sender: UIDatePicker) {
        lwh = sender.date
//        lwm = nsTimeInDSCalFormat(sender.date)
       // sender.minimumDate =
    }
    
    
    // returns appropriate calendar coordinates
//    func nsTimeInDSCalFormat (dateIn: NSDate) ->
//        Int {
//            // converting from NSCal to Integer forms
//            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Minute, .Month, .Year]
//
//            let dueDateComponents = NSCalendar.currentCalendar().components(unitFlags,
//                                                                            fromDate: dateIn)
//            
//            // finding minute coordinate.  0 is midnight of today, 1439 is 11:59 pm
//            let minuteCoordinate = (dueDateComponents.hour * 60) + dueDateComponents.minute
//
//            return minuteCoordinate
//    }
}
