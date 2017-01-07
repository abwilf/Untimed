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
    var dsCalAdjustedStartLocation: Int? = nil
    var dsCalAdjustedEndLocation: Int? = nil
    
    var startTime: NSDate = NSDate()
    var endTime: NSDate = NSDate()
 
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