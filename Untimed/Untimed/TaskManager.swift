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
    
    
    
    var unfilteredArray: [Task] = Array(count: 40, repeatedValue: Free())
    var assignmentArray = [Assignment]()
    var orderedAssignmentArray = [Assignment]()
    


    func createOrderedArray() {
        
        // unfilteredArray
        unfilteredArray = tasks
        
        // assnArray
        assignmentArray = unfilteredArray.filter(isAssignment) as! [Assignment]
        
        // orderedAssnArray
        orderedAssignmentArray = assignmentArray
            
        // for all tasks in orderedAssnArray, get their urgency
            // for each task, run through all the spots in cal array that are free or assignment and count them up to get their amountOfFreeHoursBeforeDueDate
            
        for var i = 0; i < orderedAssignmentArray.count; ++i {
            orderedAssignmentArray[i].amountOfFreeHoursBeforeDueDate = calcFreeTimeBeforeDueDate(orderedAssignmentArray[i],         dayCoordinateIn: dueDateInCalFormat(orderedAssignmentArray[i].dueDate).dayCoordinate, hourCoordinateIn: dueDateInCalFormat(orderedAssignmentArray[i].dueDate).hourCoordinate)
        }
        
        // sort by urgency
        orderedAssignmentArray.sort(isOrderedBefore)
    }
    
    func dueDateInCalFormat(dueDate: NSDate) -> (dayCoordinate: Int, hourCoordinate: Int) {
        var dayCoordinate: Int = 0
        var hourCoordinate: Int = 0
        
        // FIXME: use for loop to calculate dayCoordinate and hourCoordinate of dueDate from orderedAssignmentArray[i].dueDate
        return (dayCoordinate, hourCoordinate)
    }
    
    func calcFreeTimeBeforeDueDate (assignmentIn: Assignment, dayCoordinateIn: Int, hourCoordinateIn: Int) -> Int {
        var freeTimeBeforeDueDate: Int = 0
        
        
        // FIXME: iterate through calendar array from right now to dueDateInCalFormat to find number of free hours before dueDate
        
        return freeTimeBeforeDueDate
    }
    
    
    
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
        // save tasks array
        let archive: NSData = NSKeyedArchiver.archivedDataWithRootObject(tasks)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archive, forKey: "SavedTasks")
        defaults.synchronize()
        
        /*
        // save cal array
        let archiveCal: NSData = NSKeyedArchiver.archivedDataWithRootObject(calendarArray)
        let defaultsCal = NSUserDefaults.standardUserDefaults()
        defaultsCal.setObject(archiveCal, forKey: "SavedCalendarArray")
        defaultsCal.synchronize()
        */
    }
    
    
    func loadFromDisc() {
        
        // tasksarray
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
        
        /*
        // calendarArray
        let defaultsCal = NSUserDefaults.standardUserDefaults()
        
        // if I'm able to get a tasks array at this key, put it into tasks, if not, create a blank one and put it into tasks
        let archiveCal = defaultsCal.objectForKey("SavedCalendarArray") as? NSData ?? NSData()
        // every time you open the app
        
        if let tempCal = NSKeyedUnarchiver.unarchiveObjectWithData(archiveCal) as? [[Task]] {
            calendarArray = tempCal
        }
            
        else {
            calendarArray = []
        }
        */
    }
    
    
    
    func allocateAssignments() {
        // make an assignments only array and order it by urgency
        createOrderedArray()
        
        // if there are no assignments to allocate, kick out
        if orderedAssignmentArray.isEmpty {
            return
        }
            
        // if not, allocate assignments
        else {
            // while most urgent still has time left to allocate, allocate it
            var xIn: Int = 0
            var yIn: Int = 0
            
            // afterwards
            while orderedAssignmentArray[0].timeNeeded > 0 {
                
                // declare location variables to pass into putAssg function
                let temp = putAssgInCalArrayAtFirstFreeOrAssignmentSpot(orderedAssignmentArray[0], x: xIn, y: yIn)
                xIn = temp.xOut
                yIn = temp.yOut
                
                // decrement time needed of most urgent
                orderedAssignmentArray[0].timeNeeded -= 1
                // reorder array
                orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
            }
        return
        }
    }
    
    func allocateTime() {
        // put appts and free time in
        putApptsAndFreeTimeInCalArray()
        // allocate Assignments
        allocateAssignments()
        
        //FIXME: YES?
        //save()
    }
        
    
        
        
       
    
    func putApptsAndFreeTimeInCalArray() {
        
        let currentDate = NSDate()

        // put appointments in the calendar array
        for var i = 0; i < self.tasks.count; ++i {
           
            // if object == appointment, assign to calendarArray
            if let appt = self.tasks[i] as? Appointment {
                
                //gets difference in hour value to allocate rows
                let diffDateComponentsHour = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: appt.startTime, toDate: appt.endTime, options: NSCalendarOptions.init(rawValue: 0))
                
                // gets int value of day (april 12 = 12) component of currentDate to allocate cols difference
                let componentsNow = NSCalendar.currentCalendar().components([.Day], fromDate: currentDate)
                let currentDay = componentsNow.day
                
                // gets same info for day of appt
                let componentsAppt = NSCalendar.currentCalendar().components([.Day], fromDate: appt.startTime)
                let apptDay = componentsAppt.day
                
                // day difference = place in col array
                let dayDiff = apptDay - currentDay
                
                let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
                
                let startTimeComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: appt.startTime)
                
                if dayDiff < 0 {
                    deleteTaskAtIndex(i)
                }
                
                else {
                    for var j = 0; j < 12; ++j {
                        // NOTE: possibly limited to two dates within the same month
                        if startTimeComponents.hour == j + 8 {
                            for var k = 0; k < (diffDateComponentsHour.hour); ++k {
                                // compare today to day of appt to put in cal array
                                self.calendarArray[j + k][dayDiff] = appt
                            }
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
                else if let _ = self.calendarArray[i][j] as? Assignment {
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
   
    
    func putAssgInCalArrayAtFirstFreeOrAssignmentSpot(assg: Assignment, x: Int, y: Int) -> (xOut: Int, yOut: Int) {
        var xOut = 0
        var yOut = 0
        // go through cal array, starting at the place we last allocated at
        for var j = x; j < 28; ++j {
            for var i = y; i < 12; ++i {
                // if Free, set assignment equal to spot in cal array
                if let _ = calendarArray[i][j] as? Free {
                    calendarArray[i][j] = assg
                    
                    // hours cannot go beyond the 11 slots
                    if i + 1 <= 11 {
                        yOut = i + 1
                        xOut = j
                    }
                    
                    // if it is more than 11, increment day and restart hour
                    else {
                        yOut = 0
                        xOut = j + 1
                    }
                    return (xOut, yOut)
                }
                if let _ = calendarArray[i][j] as? Assignment {
                    // find that position in calendar array in tasks list and increment its time needed by one because we're about to replace it w/ a more urgent assn
                    
                    for var k = 0; k < orderedAssignmentArray.count; ++k {
                        if let temp = calendarArray[i][j] as? Assignment {
                            // iterate through orderedAssn looking for the object in calArray
                            if  temp == orderedAssignmentArray[k] {
                                orderedAssignmentArray[k].timeNeeded += 1
                                calendarArray[i][j] = assg
                                // hours cannot go beyond the 11 slots
                                if i + 1 <= 11 {
                                    // next time, start at the next hour spot
                                    yOut = i + 1
                                    xOut = j
                                }
                                    
                                    // if it is more than 11, increment day and restart hour
                                else {
                                    yOut = 0
                                    xOut = j + 1
                                }
                                return (xOut, yOut)
                            }
                        }
                    }
                }
                
            }
        }
        return (xOut, yOut)
    }
    
    init () {
        // also initializes member variables (tasks array)
        loadFromDisc()
        allocateTime()
    }
}