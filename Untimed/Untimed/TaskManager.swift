//
//  TaskManager.swift
//  Untimed
//
//  Created by Alex Wilf on 3/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class TaskManager {
    // Assignment and Appointment inherit Task's non default constructor
    
    //var tasks: [Task] = [Assignment(title: "Make an app"), Appointment(title: "ML Dorf")]
    
    // empty array of tasks
    var tasks: [Task] = []
    
    // calendar array
    var calendarArray = [[Task]]()
    
    
    func addTask (taskIn: Task) {
        // add to array
        tasks += [taskIn]
        save()
    }
    
    func deleteTaskAtIndex (index: Int) {
        tasks.removeAtIndex(index)
        save()
    }
    
    
    // add save method
    func save() {
        // when delete or save
        // problem: can't save taskobject to disc directly: use NSCoding to save custom classes to disc
        // specify where you want to be stored
        // watch out for the word documents
        
        let archive: NSData = NSKeyedArchiver.archivedDataWithRootObject(tasks)

        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(archive, forKey: "SavedTasks")
        
        // actually set object (ios optimizes)
        defaults.synchronize()
    }
    
    
    func loadFromDisc() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // if I'm able to get a tasks array at this key, put it into tasks, if not, create a blank one and put it into tasks
        let archive = defaults.objectForKey("SavedTasks") as? NSData ?? NSData()
        // every time you open the app
        
        if let temp = NSKeyedUnarchiver.unarchiveObjectWithData(archive) as? [Task] {
            tasks = temp
        }
        
        else {
            tasks = []
        }
    }
    
    init () {
        // also initializes member variables (tasks array)
        loadFromDisc()
    }
}