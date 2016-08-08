//
//  ProjectTask.swift
//  Untimed
//
//  Created by Alex Wilf on 7/29/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class ProjectTask: Task {
//    var projInClassArrIndex: Int = 0
//    var projInTaskArrIndex: Int = 0
    var numBlocksNeeded = 0
    
    var indexInProjAndAssnArr: Int? = nil

    override init() {
        super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"Title")
        aCoder.encodeInteger(numBlocksNeeded, forKey: "numBlocksNeeded")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        aDecoder.decodeObjectForKey("Title") as! String
        self.numBlocksNeeded = aDecoder.decodeIntegerForKey("numBlocksNeeded")
    }
}
