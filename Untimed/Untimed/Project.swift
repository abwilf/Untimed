//
//  Project.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/22/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class Project: Task {
    
    var hoursToWorkOn: Int? = nil
    var hoursCompleted: Int = 0
    var hoursLeftToWorkOn: Int {
        return hoursToWorkOn! - hoursCompleted
    }
    
    var tasks: [Task] = []
}