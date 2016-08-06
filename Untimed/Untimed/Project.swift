//
//  Project.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/22/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class Project: Task {
    var classClassArrIndex: Int = 0
    var classTaskArrIndex: Int = 0
    
    var projTaskArr: [ProjectTask] = []
    var hoursToWorkOn: Int? = nil
    var hoursCompleted: Int = 0
    var hoursLeftToWorkOn: Int {
        return hoursToWorkOn! - hoursCompleted
    }
    
    var completionDate: NSDate? = nil
    var tasks: [Task] = []
}