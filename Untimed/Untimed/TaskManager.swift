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
    let CELLS_PER_DAY = 12
    
    // calendar array
    var calendarArray: [[Task]] = Array(count: 12, repeatedValue: Array(count: 28, repeatedValue: Free()))
    
    var unfilteredArray: [Task] = Array(count: 40, repeatedValue: Free())
    var assignmentArray = [Assignment]()
    var orderedAssignmentArray = [Assignment]()
    


    private func createOrderedArray() {
        
        // turn tasks into array of Assignments
        unfilteredArray = tasks
        assignmentArray = unfilteredArray.filter(isAssignment) as! [Assignment]
        orderedAssignmentArray = assignmentArray
        
        // reinitialize hoursleft of all orderedAssnArray elements to timeNeeded - timeComplete
        for var j = 0; j < orderedAssignmentArray.count; ++j {
            orderedAssignmentArray[j].hoursLeftToAllocate = Int(orderedAssignmentArray[j].timeNeeded) - orderedAssignmentArray[j].timeCompleted
        }
        
        
        // assign free hours before due date to all assignments in orderedArray
        for var i = 0; i < orderedAssignmentArray.count; ++i {
            let assignment = orderedAssignmentArray[i]
            let assnDueDate = dueDateInCalFormat(assignment.dueDate)
            orderedAssignmentArray[i].amountOfFreeHoursBeforeDueDate = calcFreeTimeBeforeDueDate(assignment, dayCoordinateIn: assnDueDate.dayCoordinate, hourCoordinateIn: assnDueDate.hourCoordinate)
        }
        
        // sort by urgency, which is based now on hoursLeft
        orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
    }
    
    // returns appropriate calendar coords 
    func dueDateInCalFormat(dueDate: NSDate) -> (dayCoordinate: Int, hourCoordinate: Int) {
        var dayCoordinate: Int = 0
        var hourCoordinate: Int = 0
        
        let currentDate = NSDate()
        
        let componentsNowDay = NSCalendar.currentCalendar().components([.Day], fromDate: currentDate)
        let currentDay = componentsNowDay.day
        
        let componentsDueDateDay = NSCalendar.currentCalendar().components([.Day], fromDate: dueDate)
        let dueDateDay = componentsDueDateDay.day
        
        let componentsDueDateHour = NSCalendar.currentCalendar().components([.Hour], fromDate: dueDate)
        let dueDateHour = componentsDueDateHour.hour
        
        // day difference = place in col array
        let dayDiff = dueDateDay - currentDay
        
        // conversion factor
        let hourDiff = dueDateHour - 8
        
        dayCoordinate = dayDiff
        hourCoordinate = hourDiff
        
        return (dayCoordinate, hourCoordinate)
    }
    
    func calcFreeTimeBeforeDueDate (assignmentIn: Assignment, dayCoordinateIn: Int, hourCoordinateIn: Int) -> Int {
        var freeTimeBeforeDueDate: Int = 0
    
        let currentDate = NSDate()
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: currentDate, toDate: assignmentIn.dueDate, options: NSCalendarOptions.init(rawValue: 0))
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let currentDateComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: currentDate)
        let dueDateComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: assignmentIn.dueDate)

        // let currentDate = NSDate()
        
        let componentsNowDay = NSCalendar.currentCalendar().components([.Day], fromDate: currentDate)
        let currentDay = componentsNowDay.day
        
        let componentsDueDateDay = NSCalendar.currentCalendar().components([.Day], fromDate: assignmentIn.dueDate)
        let dueDateDay = componentsDueDateDay.day
        
        
        
        // day difference = place in col array
        let dayDiff = dueDateDay - currentDay
        
        // iterate through calendar array from right now to dueDateInCalFormat and count up find number of free or assignment hour blocks before dueDate
        
        // iterate through today from current hour until end of day
        for var k = currentDateComponents.hour - 7; k < CELLS_PER_DAY; ++k {
            if let _ = calendarArray[k][0] as? Free {
                freeTimeBeforeDueDate += 1
            }
            if let _ = calendarArray[k][0] as? Assignment {
                freeTimeBeforeDueDate += 1
            }
        }
        // iterate through all hours of days that aren't current day or dueDate.day
        for var j = 1; j < dayDiff - 1; ++j {
            for var i = 0; i < CELLS_PER_DAY; ++i {
                if let _ = calendarArray[i][j] as? Free {
                    freeTimeBeforeDueDate += 1
                }
                if let _ = calendarArray[i][j] as? Assignment {
                    freeTimeBeforeDueDate += 1
                }
            }
        }
        // starting at first hour value, iterate until dueDate.hour
        for var m = 0; m < dueDateComponents.hour - 8; ++m {
            if let _ = calendarArray[m][dayDiff] as? Free {
                freeTimeBeforeDueDate += 1
            }
            if let _ = calendarArray[m][dayDiff] as? Assignment {
                freeTimeBeforeDueDate += 1
            }
        }
        
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
        
    }
    
    
    
    func allocateAssignments() {
        // make an assignments only array and order it by urgency (based on hoursleft)
        createOrderedArray()
        
        // if there are no assignments to allocate, kick out
        if orderedAssignmentArray.isEmpty {
            return
        }
            
        // if not, allocate assignments
        else {
            
            // start at today
            var dayIn: Int = 0
            
            // start at current hour
            let currentDate = NSDate()
            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
            let currentDateComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: currentDate)
            var hourIn = currentDateComponents.hour - 7
            
            
            // create free object to assign
            let freeObj = Free()
            
            
            // clear calendar array of all assignments for the rest of today
            for var i = hourIn; i < CELLS_PER_DAY; ++i {
                if let _ = calendarArray[i][dayIn] as? Assignment {
                    calendarArray[i][dayIn] = freeObj
                }
            }
            
            // clear for every day afterwards
            for var j = dayIn + 1; j < 28; ++j {
                // FIXME: should start at current hour then run through each day starting at index zero
                for var i = 0; i < CELLS_PER_DAY; ++i {
                    // if spot is assignment, make it free
                    if let _ = calendarArray[i][j] as? Assignment {
                        calendarArray[i][j] = freeObj
                    }
                }
            }

            
            // allocate
            while orderedAssignmentArray[0].hoursLeftToAllocate > 0 {
                // put in at first available spot starting from now
                let temp = putAssgInCalArrayAtFirstFreeOrAssignmentSpot(orderedAssignmentArray[0], day: dayIn, hour: hourIn)
                dayIn = temp.dayOut
                hourIn = temp.hourOut
                
                // decrement hoursLeft of most urgent
                orderedAssignmentArray[0].hoursLeftToAllocate -= 1
                // sort by urgency
                orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
            }
        return
        }
    }
    
    func allocateTime() {
        // clear out past tasks
        deletePastTasks()
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
                    for var j = 0; j < CELLS_PER_DAY; ++j {
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
        
        for var i = 0; i < CELLS_PER_DAY; ++i {
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
        // less is more urgent
        if a1.urgency < a2.urgency {
            return true
        }
        return false
    }
   
    
    func putAssgInCalArrayAtFirstFreeOrAssignmentSpot(assg: Assignment, day: Int, hour: Int) -> (dayOut: Int, hourOut: Int) {
        var dayOut = 0
        var hourOut = 0
        // go through cal array, starting at the place we last allocated at
        for var j = day; j < 28; ++j {
            for var i = hour; i < CELLS_PER_DAY; ++i {
                // if Free, set assignment equal to spot in cal array
                if let _ = calendarArray[i][j] as? Free {
                    calendarArray[i][j] = assg
                    
                    // hours cannot go beyond the 11 slots
                    if i + 1 <= 11 {
                        hourOut = i + 1
                        dayOut = j
                    }
                    
                    // if it is more than 11, increment day and restart hour
                    else {
                        hourOut = 0
                        dayOut = j + 1
                    }
                    return (dayOut, hourOut)
                }
                if let _ = calendarArray[i][j] as? Assignment {
                    // find that position in calendar array in tasks list and increment its time needed by one because we're about to replace it w/ a more urgent assn
                   print("ERROR! Calendar array was not properly cleared, or this allocation did not start at the correct spot (one after the previous slot was allocated to)")
                    
                }
            }
            
        }
        return (dayOut, hourOut)

    }
    
    func deletePastTasks() {
        let currentDate = NSDate()
        for var i = 0; i < tasks.count; ++i {
            
            if let temp = tasks[i] as? Appointment {
                
                let componentsNowDay = NSCalendar.currentCalendar().components([.Day], fromDate: currentDate)
                let currentDay = componentsNowDay.day
                
                let componentsEndTimeDay = NSCalendar.currentCalendar().components([.Day], fromDate: temp.endTime)
                let endTimeDay = componentsEndTimeDay.day
                
                let componentsEndTimeHour = NSCalendar.currentCalendar().components([.Hour], fromDate: temp.endTime)
                let endTimeHour = componentsEndTimeHour.hour
                
                // day difference = place in col array
                let dayDiff = endTimeDay - currentDay
                
                // conversion factor
                let hourDiff = endTimeHour - 8
                
                if dayDiff < 0 {
                    deleteTaskAtIndex(i)
                }
                if dayDiff == 0 && hourDiff < 0 {
                    deleteTaskAtIndex(i)
                }
            }
            if let temp = tasks[i] as? Assignment {
                let componentsNowDay = NSCalendar.currentCalendar().components([.Day], fromDate: currentDate)
                let currentDay = componentsNowDay.day
                
                let componentsDueDateDay = NSCalendar.currentCalendar().components([.Day], fromDate: temp.dueDate)
                let DueDateDay = componentsDueDateDay.day
                
                let componentsDueDateHour = NSCalendar.currentCalendar().components([.Hour], fromDate: temp.dueDate)
                let DueDateHour = componentsDueDateHour.hour
                
                // day difference = place in col array
                let dayDiff = DueDateDay - currentDay
                
                // conversion factor
                let hourDiff = DueDateHour - 8
                
                if dayDiff < 0 {
                    deleteTaskAtIndex(i)
                }
                if dayDiff == 0 && hourDiff < 0 {
                    deleteTaskAtIndex(i)
                }
            }
            
            
        }
    }

    init () {
        // also initializes member variables (tasks array)
        loadFromDisc()
        allocateTime()
    }
}