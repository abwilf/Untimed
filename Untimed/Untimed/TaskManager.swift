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
        putApptsAndFreeTimeInCalArray()
        
        // put ordered assignments
        for var i = 0; i < orderedAssignmentArray.count; i++ {
            putAssgInCalArrayAtFirstFreeSpot()
        }
    }
    
    func putApptsAndFreeTimeInCalArray() -> [[Task]]{
        
        let currentDate = NSDate()
        // FIXME: calendarArray is now a member variable of taskmanager
        // #3: put appointments in the calendar array by pulling them from tasks array
        for var i = 0; i < self.tasks.count; ++i {
            
            // if object == appointment, assign to calendarArray
            if let appt = self.tasks[i] as? Appointment {
                
                //Puts appointment in to correct spot in array
                
                let diffDateComponentsHour = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: appt.startTime, toDate: appt.endTime, options: NSCalendarOptions.init(rawValue: 0))
                
                let diffDateComponentsDay = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: appt.endTime, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
                
                let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
                
                let startTimeComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: appt.startTime)
                
                
                for var i = 0; i < 12; ++i {
                    
                    // NOTE: possibly limited to two dates within the same month
                    if startTimeComponents.hour == i + 8 {
                        for var k = 0; k < (diffDateComponentsHour.hour); ++k {
                            self.calendarArray[diffDateComponentsDay.day][i + k] = appt
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
       
        var assignmentArray = tasks.filter(isAssignment)
    
        
        func isOrderedBefore (a1: Task, a2: Task) -> Bool {
            if let assn1 = a1 as? Assignment {
                if let assn2 = a2 as? Assignment {
                    if assn1.urgency < assn2.urgency {
                        return true
                    }
                    return false
                }
            }
            
        }
   
       
        let orderedAssignmentArray = assignmentArray.sort(isOrderedBefore)
        
    
    func putAssgInCalArrayAtFirstFreeSpot(assg: Assignment) -> Bool {
        
        for var j = 0; j < 28; ++j {
            for var i = 0; i < 12; ++i {
                if let _ = self.calendarArray[i][j] as? Assignment {
                    self.calendarArray[i][j] = assg
                    return true
                }
            }
        }
        return false
    }
    
    
    
    // FIXME: check if this only happens cell by cell, TEST: timeNeeded is correct in more than 1 hr blocks
//    func findMostUrgentAssnAndAllocateToCalArray() {
//        
//        // find most urgent
//        
//        // assign winner to first object of type Assignment in the array
//        var winner: Assignment = Assignment()
//        let defaultAssignment: Assignment = Assignment()
//        var tasksIndex = 0
//        for var i = 0; i < self.tasks.count; ++i {
//            if let currentAssignment = self.tasks[i] as? Assignment {
//                if winner == defaultAssignment {
//                    if self.tasks[i] != defaultAssignment {
//                        winner = currentAssignment
//                        tasksIndex = i
//                    }
//                }
//            }
//        }
//        
//        
//        // assign winner to the greatest
//        for var j = 0; j < self.tasks.count - tasksIndex; ++j {
//            if let moreUrgentAssn = self.tasks[tasksIndex + j] as? Assignment {
//                if moreUrgentAssn.lackOfUrgencyScore() < winner.lackOfUrgencyScore() {
//                    winner = moreUrgentAssn
//                }
//            }
//        }
//        
//        // allocate to cal array
//        for var j = 0; j < self.tasks.count; ++j {
//            if let temp = self.tasks[j] as? Assignment {
//                // if same object
//                if temp == winner {
//                    
//                    // decrement timeNeeded value by one b/c this is only allocating to one cell
//                    temp.timeNeeded -= 1
//                    
//                    // put in calendar array in the first free spot
//                    putAssgInCalArrayAtFirstFreeSpot(temp)
//                    
//                    // 12 row sections, only accounting for 28 days in the future at this point
//                }
//            }
//        }
//    }

    
    init () {
        // also initializes member variables (tasks array)
        loadFromDisc()
        allocateTime()
    }
}