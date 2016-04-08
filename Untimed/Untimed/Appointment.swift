//
//  Appointment.swift
//  Untimed
//
//  Created by Alex Wilf on 3/29/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class Appointment: Task {
    
    // to test: var startTime = "11.30"
    var startTime: NSDate = NSDate()
    
    // to test: var endTime = " 1 am tomorrow"
    var endTime: NSDate = NSDate()
    
    
    override init() {
        super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(startTime, forKey:"StartTime")
        aCoder.encodeObject(endTime, forKey:"EndTime")
        aCoder.encodeObject(title, forKey:"Title")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startTime = aDecoder.decodeObjectForKey("StartTime") as! NSDate
        self.endTime = aDecoder.decodeObjectForKey("EndTime") as! NSDate
        self.endTime = aDecoder.decodeObjectForKey("EndTime") as! NSDate
            aDecoder.decodeObjectForKey("Title") as? String
        
    }
    
}