//
//  WorkingBlock.swift
//  Untimed
//
//  Created by Alex Wilf on 7/26/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class WorkingBlock: Task {
    var focusArr: [Task] = []
    
    // should be saved if it contains a focus
    var hasFocus = false
    
    override init() {
        super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"Title")
        aCoder.encodeObject(focusArr, forKey: "focusArr")
        aCoder.encodeObject(startTime, forKey:"StartTime")
        aCoder.encodeObject(endTime, forKey:"EndTime")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        aDecoder.decodeObjectForKey("Title") as! String
        self.focusArr = aDecoder.decodeObjectForKey("focusArr") as? [Task] ?? []
        self.startTime = aDecoder.decodeObjectForKey("StartTime") as? NSDate ?? NSDate()
        self.endTime = aDecoder.decodeObjectForKey("EndTime") as? NSDate ?? NSDate()

    }
}