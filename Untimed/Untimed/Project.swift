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
    
    var indexInProjAndAssnArr: Int? = nil
    
    var projTaskArr: [ProjectTask] = []
    var hoursToWorkOn: Int? = nil
    var hoursCompleted: Int = 0
    var hoursLeftToWorkOn: Int {
        return hoursToWorkOn! - hoursCompleted
    }
    
    
    var completionDate: NSDate? = nil
    var tasks: [Task] = []
    
    func deleteElementFromProjTaskArr(indexIn: Int) {
        projTaskArr.removeAtIndex(indexIn)
    }
    
    override init() {
        super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"Title")
        aCoder.encodeObject(projTaskArr, forKey: "ProjectsTaskArr")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.projTaskArr = aDecoder.decodeObjectForKey("ProjTaskArr") as? [ProjectTask] ?? []
        aDecoder.decodeObjectForKey("Title") as! String
    }
}