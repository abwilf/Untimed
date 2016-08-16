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
    
    var timeNeeded: Double = 0
    
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
        self.timeNeeded = aDecoder.decodeObjectForKey("TimeNeeded") as! Double
        aDecoder.decodeObjectForKey("Title") as! String
        aDecoder.decodeObjectForKey("DueDate") as! NSDate
    }

}


