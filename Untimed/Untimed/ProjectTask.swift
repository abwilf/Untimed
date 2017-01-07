//
//  ProjectTask.swift
//  Untimed
//
//  Created by Alex Wilf on 7/29/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class ProjectTask: Task {
    var timeNeeded: Double = 0
    
    var indexInProjAndAssnArr: Int? = nil

    override init() {
        super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"Title")
        aCoder.encodeDouble(timeNeeded, forKey: "timeNeeded")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        aDecoder.decodeObjectForKey("Title") as! String
        self.timeNeeded = aDecoder.decodeDoubleForKey("timeNeeded")
    }
}
