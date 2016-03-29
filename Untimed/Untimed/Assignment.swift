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
    var timeNeeded: Int = 0
    var title: String = "Unnamed Assignment"
}

