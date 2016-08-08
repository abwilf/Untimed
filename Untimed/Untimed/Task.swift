//
//  Task.swift
//  Untimed
//
//  Created by Alex Wilf on 3/28/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

// Testing

import Foundation

class Task: NSObject, NSCoding {
    
    var title: String = "Unnamed Task"
    
    var dueDate: NSDate = NSDate()
//    var tasksIndex: Int = 0

    
//    // for ds allocation
//    // moving to subclasses where appropriate
//    
    var dsCalAdjustedStartLocation: Int? = nil
    var dsCalAdjustedEndLocation: Int? = nil
    
    var startTime: NSDate = NSDate()
    var endTime: NSDate = NSDate()
//
//    
//    var lock: Bool = false
//    
//    func lockTask() {
//        lock = true
//    }
//    
//    func unlockTask() {
//        lock = false
//    }
//    
//    func isLocked() -> Bool {
//        if lock == true {
//            return true
//        }
//        return false
//    }
//
//    
//    // returns number of blocks taken up by given task
//    // NOTE: should be used on AssignmentBlock and not Assignment objects
//    // FIXME: what factor is this value off by?
//    func getTaskLength() -> Int {
//        return (dsCalAdjustedStartLocation! - dsCalAdjustedEndLocation!)
//    }
//    
    init(title: String) {
        self.title = title
    }
    
    init(titleIn: String) {
        title = titleIn
    }
    
    // default initializer
    override init() {
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"Title")
    }
    
    required init (coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("Title") as? String ?? ""
    }
    
}