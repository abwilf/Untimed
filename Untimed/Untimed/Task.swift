//
//  Task.swift
//  Untimed
//
//  Created by Alex Wilf on 3/28/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

// Testing

import Foundation

class Task {
    // nothing needed because subclasses reference (see assn and appt files)
    var title: String = "Unnamed Task"
    
    init(title: String) {
        self.title = title
    }
}