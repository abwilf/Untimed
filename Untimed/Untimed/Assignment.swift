//
//  Assignment.swift
//  Untimed
//
//  Created by Alex Wilf on 3/28/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

// superclass = Task
class Assignment: Task {
    var dueDate: NSDate = NSDate()
    var timeNeeded: Double = 0
    var amountOfFreeHoursBeforeDueDate: Int = 0
    
    func lackOfUrgencyScore() -> Int {
        return (amountOfFreeHoursBeforeDueDate - Int(timeNeeded))
    }
    
    
    /*
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Month, .Day], fromDate: dueDate)
    
    // why doesn't this work?
    let calendar = NSCalendar.currentCalendar()
    let dateComponents: NSDateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: dueDate)

    let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
    let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: dueDate)
    */
    
    
    
    override init() {
       super.init()
    }
    
    
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(dueDate, forKey:"DueDate")
        aCoder.encodeObject(timeNeeded, forKey:"TimeNeeded")
        aCoder.encodeObject(title, forKey:"Title")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        self.timeNeeded = aDecoder.decodeObjectForKey("TimeNeeded") as! Double
            aDecoder.decodeObjectForKey("Title") as! String
    }

}


