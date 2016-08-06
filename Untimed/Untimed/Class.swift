//
//  File.swift
//  Untimed
//
//  Created by Alex Wilf on 7/26/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class Class: Task {
    // projects and assignments that fall under one class
    var projAndAssns: [Task] = []
    
    // FIXME: this will be redundant when we implement the different add buttons
    var projOnlyArray: [Project] = []
    

//    func updateProjAndAssnIndexValues() {
//        for i in 0..<projAndAssns.count {
//            projAndAssns[i].indexInProjAndAssnArr = i
//        }
//    }
    
    func deleteElementFromProjAndAssns(indexIn: Int) {
        projAndAssns.removeAtIndex(indexIn)
    }
    
    
    override init() {
        super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"Title")
        aCoder.encodeObject(projAndAssns, forKey: "Projects and Assignments")
        aCoder.encodeInteger(tasksIndex, forKey: "tasksIndex")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.projAndAssns = aDecoder.decodeObjectForKey("Projects and Assignments") as? [Task] ?? []
        self.tasksIndex = aDecoder.decodeIntegerForKey("tasksIndex")
        aDecoder.decodeObjectForKey("Title") as! String
    }

}