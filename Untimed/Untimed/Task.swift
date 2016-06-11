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
    // nothing needed because subclasses reference (see assn and appt files)
    var title: String = "Unnamed Task"
    
    // for ds allocation
    var dsCalAdjustedStartLocation: Int = 0
    var dsCalAdjustedEndLocation: Int = 0
    
    
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