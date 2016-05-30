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
    
    // minutes
//    var minutesNeeded: Int = 0
//    var amountOfFreeMinutesBeforeDueDate: Int = 0
//    var minutesLeftToAllocate: Int = 0
//    var timeCompleted: Int = 0
    
    // working blocks
    var numFreeBlocksBeforeDueDate: Int = 0
    var numBlocksNeeded: Int = 0
    var numBlocksLeftToAllocate: Int = 0
    var numBlocksCompleted: Int = 0
    
    var dueDate: NSDate = NSDate()
    
    var urgency: Int {
        get {
            if numBlocksLeftToAllocate > 0 {
                return (numFreeBlocksBeforeDueDate - numBlocksLeftToAllocate)
            }
            else {
                return 1000000
            }
        }
    }
    
    override init() {
       super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(dueDate, forKey:"DueDate")
        aCoder.encodeObject(numBlocksNeeded, forKey:"TimeNeeded")
        aCoder.encodeObject(title, forKey:"Title")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        self.numBlocksNeeded = aDecoder.decodeObjectForKey("TimeNeeded") as! Int
            aDecoder.decodeObjectForKey("Title") as! String
    }

}


