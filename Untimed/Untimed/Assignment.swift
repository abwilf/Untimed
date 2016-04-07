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

    
   // override func encodeWithCoder(aCoder: NSCoder!) {
       // aCoder.encodeObject(dueDate, forKey:"DueDate")
       // aCoder.encodeObject(timeNeeded, forKey:"TimeNeeded")
   // }
    
    
  // override init (coder aDecoder: NSCoder!) {
       // self.dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
       // self.timeNeeded = aDecoder.decodeObjectForKey("TimeNeeded") as! Double
       // super.init()
    // }
    
    

}


