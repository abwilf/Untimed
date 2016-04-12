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
    
    // empty array of tasks
    var tasks: [Task] = []

    // calendar array
    var calendarArray: [[Task]] = Array(count: 12, repeatedValue: Array(count: 28, repeatedValue: Free()))
    
    func addTask (taskIn: Task) {
        // add to array
        tasks += [taskIn]
        save()
        allocateTime()
    }
    
    func deleteTaskAtIndex (index: Int) {
        tasks.removeAtIndex(index)
        save()
        allocateTime()
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
        
        // create calendar array
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
    
    func allocateTime() {
        // put appts and free time in
        putApptsAndFreeTimeInCalArray()
        
        // make an assignments only array and order it by urgency
        let assignmentArray = tasks.filter(isAssignment) as! [Assignment]
        var orderedAssignmentArray = assignmentArray.sort(isOrderedBefore)
        
        if orderedAssignmentArray.isEmpty {
            return
        }
        
        else {
            // while most urgent still has time left to allocate, allocate it
            while orderedAssignmentArray[0].timeNeeded > 0 {
                
                // FIXME: need to make sure you replace the timeNeeded value of the spot you took
                // FIXME: figure out which timeNeeded to modify
                putAssgInCalArrayAtFirstFreeSpot(orderedAssignmentArray[0])
                orderedAssignmentArray[0].timeNeeded -= 1
                
                // reorder array
                orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
                
                // FIXME: TODO:
                // FIXME: TODO: resave tasks array as all the tasks in calendar array
            }
        }
    }
        
        /*
        // if orderedAssignment Array isn't blank
        if orderedAssignmentArray != [] {
              // allocate one hour of the most urgent assignment to the cal array
            while orderedAssignmentArray[0].timeNeeded > 0 {
                
                // FIXME: need to make sure you replace the timeNeeded value of the spot you took
                putAssgInCalArrayAtFirstFreeSpot(orderedAssignmentArray[0])
                orderedAssignmentArray[0].timeNeeded -= 1
               
                // reorder array
                orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)

            }
        */
        
        
       
    
    func putApptsAndFreeTimeInCalArray() {
        
        let currentDate = NSDate()

        // put appointments in the calendar array
        for var i = 0; i < self.tasks.count; ++i {
           
            // if object == appointment, assign to calendarArray
            if let appt = self.tasks[i] as? Appointment {
                
                //Puts appointment in to correct spot in array
                let diffDateComponentsHour = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: appt.startTime, toDate: appt.endTime, options: NSCalendarOptions.init(rawValue: 0))
                
                let diffDateComponentsDay = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: currentDate, toDate: appt.endTime, options: NSCalendarOptions.init(rawValue: 0))
                
                let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
                
                let startTimeComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: appt.startTime)
                
                for var j = 0; j < 12; ++j {
                    // NOTE: possibly limited to two dates within the same month
                    if startTimeComponents.hour == j + 8 {
                        for var k = 0; k < (diffDateComponentsHour.hour); ++k {
                            // compare today to tomorrow
                            self.calendarArray[j + k][diffDateComponentsDay.day] = appt
                        }
                    }
                }
            }
        }
        
        
        // declare free object
        let freeTime: Free = Free()
        
        // put free object in all slots not occupied by appointment
        
        for var i = 0; i < 12; ++i {
            for var j = 0; j < 28; ++j {
                
                // if the spot is taken by an appointment ignore it
                if let _ = self.calendarArray[i][j] as? Appointment {
                }
                    
                    // otherwise, allocate a free object to it
                else {
                    self.calendarArray[i][j] = freeTime
                }
            }
        }
    }
    
        
    // Create sorted array of assignments
        
    func isAssignment (t: Task) -> Bool {
        if let _ = t as? Assignment {
            return true
        }
        return false
    }

    func isOrderedBefore (a1: Assignment, a2: Assignment) -> Bool {
        if a1.urgency < a2.urgency {
            return true
        }
        return false
    }
   
    
    func putAssgInCalArrayAtFirstFreeSpot(assg: Assignment) -> Bool {
        
        for var j = 0; j < 28; ++j {
            for var i = 0; i < 12; ++i {
                if let _ = self.calendarArray[i][j] as? Free {
                    // if there was already an assignment there, replace it and increase its timeNeeded value by 1
                    self.calendarArray[i][j] = assg
                    return true
                }
            }
        }
        return false
    }
    
    init () {
        // also initializes member variables (tasks array)
        loadFromDisc()
        allocateTime()
    }
}