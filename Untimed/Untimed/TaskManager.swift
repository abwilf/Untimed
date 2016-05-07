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
    
    let HOURS_IN_DAY = 12
    let MINS_IN_HOUR = 60
    // 15 min intervals
    let BLOCK_INTERVAL_SIZE = 60
    var cellsPerDay = -1
    
    let FIRST_WORKING_HOUR = 8
    let LAST_WORKING_HOUR = 20
    
    // calendar array = 2d array of 12 hours by 28 days
    var calendarArray: [[Task]] = Array(count: 12,
        repeatedValue: Array(count: 28, repeatedValue: Free()))
    
    // create variables to order array later
    var unfilteredArray: [Task] = Array(count: 40, repeatedValue: Free())
    var assignmentArray = [Assignment]()
    var orderedAssignmentArray = [Assignment]()
    
    
    
    private func createOrderedArray() {
        
        // turn tasksarray  into array of Assignments
        unfilteredArray = tasks
        assignmentArray = unfilteredArray.filter(isAssignment) as! [Assignment]
        orderedAssignmentArray = assignmentArray
        
        // reinitialize hoursleft of all elements to timeNeeded - timeComplete
        for var j = 0; j < orderedAssignmentArray.count; ++j {
            orderedAssignmentArray[j].hoursLeftToAllocate =
                Int(orderedAssignmentArray[j].timeNeeded) -
                orderedAssignmentArray[j].timeCompleted
        }
        
        // assign free hours before due date to all assignments in orderedArray
        for var i = 0; i < orderedAssignmentArray.count; ++i {
            let assignment = orderedAssignmentArray[i]
            orderedAssignmentArray[i].amountOfFreeHoursBeforeDueDate =
                calcFreeTimeBeforeDueDate(assignment)
        }
        
        // sort by urgency, which is based now on hoursLeft
        orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
    }
    
    func setCellsPerDay() {
        cellsPerDay = HOURS_IN_DAY * (MINS_IN_HOUR / BLOCK_INTERVAL_SIZE)
    }
        
    
    // returns appropriate calendar coords
    func nsDateInCalFormat(nsDateObject: NSDate) ->
        (dayCoordinate: Int, hourCoordinate: Int) {
        var dayCoordinate: Int = 0
        var hourCoordinate: Int = 0
        
            let currentDate = NSDate()
            
            let componentsNowDay = NSCalendar.currentCalendar().components([.Day],
                fromDate: currentDate)
            let currentDay = componentsNowDay.day
            
            let componentsDueDateDay = NSCalendar.currentCalendar().components([.Day],
                fromDate: nsDateObject)
            let dueDateDay = componentsDueDateDay.day
            
            let componentsDueDateHour = NSCalendar.currentCalendar().components([.Hour],
                fromDate: nsDateObject)
            let dueDateHour = componentsDueDateHour.hour
            
            // day difference = place in col array
            let dayDiff = dueDateDay - currentDay
            
            // conversion factor
            let hourDiff = dueDateHour - 8
            
            dayCoordinate = dayDiff
            hourCoordinate = hourDiff
            
            return (dayCoordinate, hourCoordinate)
    }
    
    func calcFreeTimeBeforeDueDate (assignmentIn: Assignment) -> Int {
        var freeTimeBeforeDueDate: Int = 0
        
        let currentDate = NSDate()
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let currentDateComponents = NSCalendar.currentCalendar().components(unitFlags,
                                                                            fromDate: currentDate)
        let dueDateComponents = NSCalendar.currentCalendar().components(unitFlags,
                                                                        fromDate: assignmentIn.dueDate)
        
        // let currentDate = NSDate()
        
        let componentsNowDay = NSCalendar.currentCalendar().components([.Day], fromDate: currentDate)
        let currentDay = componentsNowDay.day
        
        let componentsDueDateDay = NSCalendar.currentCalendar().components([.Day], fromDate: assignmentIn.dueDate)
        let dueDateDay = componentsDueDateDay.day
        
        
        
        // day difference = place in col array
        let dayDiff = dueDateDay - currentDay
        
        // iterate through calendar array from right now to dueDateInCalFormat and count up find number of free or assignment hour blocks before dueDate
        

        if dayDiff == 0 {
            if dueDateComponents.hour <= LAST_WORKING_HOUR - 1 {
                for var k = currentDateComponents.hour - FIRST_WORKING_HOUR + 1; k < dueDateComponents.hour - FIRST_WORKING_HOUR; ++k {
                    if let _ = calendarArray[k][0] as? Free {
                        freeTimeBeforeDueDate += 1
                    }
                    if let _ = calendarArray[k][0] as? Assignment {
                        freeTimeBeforeDueDate += 1
                    }
                }
            }
        }
        
        else {
            // iterate through today from current hour until end of day
            for var k = currentDateComponents.hour - 7; k < cellsPerDay; ++k {
                if let _ = calendarArray[k][0] as? Free {
                    freeTimeBeforeDueDate += 1
                }
                if let _ = calendarArray[k][0] as? Assignment {
                    freeTimeBeforeDueDate += 1
                }
            }
            // iterate through all hours of days that aren't current day or dueDate.day
            for var j = 1; j < dayDiff; ++j {
                for var i = 0; i < cellsPerDay; ++i {
                    if let _ = calendarArray[i][j] as? Free {
                        freeTimeBeforeDueDate += 1
                    }
                    if let _ = calendarArray[i][j] as? Assignment {
                        freeTimeBeforeDueDate += 1
                    }
                }
            }
            
            
            
            // on the due date, if it's due within our range
            if dueDateComponents.hour >= 8 && dueDateComponents.hour <= 19 {
                // starting at first hour value of dueDate day, 
                // iterate until dueDate.hour and find free time
                for var m = 0; m < dueDateComponents.hour - 8; ++m {
                    if let _ = calendarArray[m][dayDiff] as? Free {
                        freeTimeBeforeDueDate += 1
                    }
                    if let _ = calendarArray[m][dayDiff] as? Assignment {
                        freeTimeBeforeDueDate += 1
                    }
                }
            }
            
            // on the due date, if it's not due within our range (before 8 am)
            if dueDateComponents.hour < 8 {
                return freeTimeBeforeDueDate
            }
            
            // on the due date, if it's
            if dueDateComponents.hour == 20 {
                for var m = 0; m < dueDateComponents.hour - 9; ++m {
                    if let _ = calendarArray[m][dayDiff] as? Free {
                        freeTimeBeforeDueDate += 1
                    }
                    if let _ = calendarArray[m][dayDiff] as? Assignment {
                        freeTimeBeforeDueDate += 1
                    }
                }
            }
            
            if dueDateComponents.hour == 21 {
                for var m = 0; m < dueDateComponents.hour - 10; ++m {
                    if let _ = calendarArray[m][dayDiff] as? Free {
                        freeTimeBeforeDueDate += 1
                    }
                    if let _ = calendarArray[m][dayDiff] as? Assignment {
                        freeTimeBeforeDueDate += 1
                    }
                }
            }
                
            if dueDateComponents.hour == 22 {
                for var m = 0; m < dueDateComponents.hour - 11; ++m {
                    if let _ = calendarArray[m][dayDiff] as? Free {
                        freeTimeBeforeDueDate += 1
                    }
                    if let _ = calendarArray[m][dayDiff] as? Assignment {
                        freeTimeBeforeDueDate += 1
                    }
                }
            }
                
            if dueDateComponents.hour == 23 {
                for var m = 0; m < dueDateComponents.hour - 12; ++m {
                    if let _ = calendarArray[m][dayDiff] as? Free {
                        freeTimeBeforeDueDate += 1
                    }
                    if let _ = calendarArray[m][dayDiff] as? Assignment {
                        freeTimeBeforeDueDate += 1
                    }
                }
            }
                
          
            
            // if it's after the 8 block
            else if dueDateComponents.hour > 19 {
                // count up the amount of free time up to 19
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
        
        // if I'm able to get a tasks array at this key, put it into tasks, 
        // if not, create a blank one and put it into tasks
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
            let currentDateComponents =
                NSCalendar.currentCalendar().components(unitFlags, fromDate: currentDate)
            var hourIn = currentDateComponents.hour - 7
            
            // if not enough time to complete assignment before due date, make hourslefttoallocate = amountofFreeTime (so you use up all your time on the assignment)
            
            if orderedAssignmentArray[0].amountOfFreeHoursBeforeDueDate < Int(orderedAssignmentArray[0].hoursLeftToAllocate) {
                orderedAssignmentArray[0].hoursLeftToAllocate = orderedAssignmentArray[0].amountOfFreeHoursBeforeDueDate
            }
            
            // allocate
            while orderedAssignmentArray[0].hoursLeftToAllocate > 0 {
                // put in at first available spot starting from now
                let temp =
                    putAssgInCalArrayAtFirstFreeOrAssignmentSpot(orderedAssignmentArray[0], day: dayIn, hour: hourIn)
                dayIn = temp.dayOut
                hourIn = temp.hourOut
                
                // if hourIn = 0, it means it went to the next day and didn't allocate
                if hourIn != 0 {
                    // decrement hoursLeft of most urgent
                    orderedAssignmentArray[0].hoursLeftToAllocate -= 1
                    // sort by urgency
                    orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
                }
            }
            return
        }
    }
    
    func allocateTime() {
        setCellsPerDay()
        // clear out past tasks in task list
        deletePastTasks()
        
        // clear out all future spots in cal array before allocating again from tasks list
        clearFutureCalArray()
        
        // put appts and free time in
        allocateApptsAndFreeTime()
        // allocate Assignments
        allocateAssignments()
    }
    
    
    
    
    func clearFutureCalArray() {
        // start at today
        let dayIn: Int = 0
        
        // start at current hour
        let currentDate = NSDate()
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let currentDateComponents =
            NSCalendar.currentCalendar().components(unitFlags, fromDate: currentDate)
        let hourIn = currentDateComponents.hour - 7
        
        
        // create free object to assign
        let freeObj = Free()
        
        
        // clear calendar array of all assignments for the rest of today
        for var i = hourIn; i < cellsPerDay; ++i {
            calendarArray[i][dayIn] = freeObj
        }
        
        // clear for every day afterwards
        for var j = dayIn + 1; j < 28; ++j {
            for var i = 0; i < cellsPerDay; ++i {
                calendarArray[i][j] = freeObj
            }
        }
    }
    
    func allocateApptsAndFreeTime() {
        
        let currentDate = NSDate()
        for var i = 0; i < self.tasks.count; ++i {
            
            // part I: if object is an appointment, assign to calendarArray
            if let appt = self.tasks[i] as? Appointment {
                
                // declare units to call from NSCalendar format
                let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
                
                // declare components
                let startTimeComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: appt.startTime)
                let endTimeComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: appt.endTime)
                let componentsNow = NSCalendar.currentCalendar().components([.Day], fromDate: currentDate)
                
                // declare variables using components
                let currentDay = componentsNow.day
                let apptDay = startTimeComponents.day
                let dayDiffEndAndStart = endTimeComponents.day - startTimeComponents.day
                var hourDiffEndAndStart = endTimeComponents.hour - startTimeComponents.hour
                
                
                // day difference = location in calendar array
                let dayDiffApptAndNow = apptDay - currentDay
                
                // if appt is before today, delete (though minimum constraint should stop the user from doing this, this is a good backup)
                if dayDiffApptAndNow < 0 {
                    deleteTaskAtIndex(i)
                }
                
                // fill up the block if it has minutes in it
                if endTimeComponents.minute > 0 && endTimeComponents.hour < cellsPerDay + 7 {
                    hourDiffEndAndStart += 1
                }
               
                // if end time is before or same as start, don't allocate, and set name = to error message
                if dayDiffEndAndStart == 0 && hourDiffEndAndStart <= 0 {
                    tasks[i].title += " -- Warning: end time must be after start"
                }

                // if you set the appointment out of range, only allocate within the range
                if hourDiffEndAndStart > 12 {
                    hourDiffEndAndStart = 12
                }
                
                // if it starts before 8 am, start it at 8
                if startTimeComponents.hour < 8 {
                    startTimeComponents.hour = 8
                }
                // allocate
                for var j = 0; j < cellsPerDay; ++j {
                    // k being less than hourDiff stops appts with end times before their start times from being run
                    if startTimeComponents.hour == j + 8 {
                        for var k = 0; k < (hourDiffEndAndStart); ++k {
                            // compare today to day of appt to put in cal array
                            self.calendarArray[j + k][dayDiffApptAndNow] = appt
                        }
                    }
                }
                
             
                
            }
        }
        
        // part II: put free object in all slots not occupied by appointment

        // declare free object
        let freeTime: Free = Free()
        
        // allocate them
        for var i = 0; i < cellsPerDay; ++i {
            for var j = 0; j < 28; ++j {
                
                // if the spot is taken by an appointment ignore it
                if let _ = self.calendarArray[i][j] as? Appointment {
                }
                
                // otherwise, allocate a free object to it
                else if let _ = self.calendarArray[i][j] as? Assignment {
                }
                
                else {
                    self.calendarArray[i][j] = freeTime
                }
            }
        }
    }
    
    // used in creating a sorted array of assignments
    func isAssignment (t: Task) -> Bool {
        if let _ = t as? Assignment {
            return true
        }
        return false
    }
    
    // used in creating ordered array
    func isOrderedBefore (a1: Assignment, a2: Assignment) -> Bool {
        if a1.urgency < a2.urgency {
            return true
        }
        return false
    }
    
    
    func putAssgInCalArrayAtFirstFreeOrAssignmentSpot(assg: Assignment, day: Int, hour: Int) -> (dayOut: Int, hourOut: Int) {
        var dayOut = 0
        var hourOut = 0
        
        if hour >= cellsPerDay {
            hourOut = 0
            dayOut = 1
            return (dayOut, hourOut)
        }
        
        // go through cal array, starting at the place we last allocated at
        for var j = day; j < 28; ++j {
            for var i = hour; i < cellsPerDay; ++i {
                // if Free, set assignment equal to spot in cal array
                if let _ = calendarArray[i][j] as? Free {
                    calendarArray[i][j] = assg
                    
                    // hours cannot go beyond the 11 slots
                    if i + 1 <= 11 {
                        hourOut = i + 1
                        dayOut = j
                    }
                        
                    // if they do, increment day and restart hour
                    else {
                        hourOut = 0
                        dayOut = j + 1
                    }
                    
                    // return where we last allocated, so we can restart here
                    return (dayOut, hourOut)
                }
                if let _ = calendarArray[i][j] as? Assignment {
                    // print error message to developer because cal array should have been wiped
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
                
                // day difference = place in col array
                let dayDiff = endTimeDay - currentDay
                
                if dayDiff < 0 {
                    deleteTaskAtIndex(i)
                }
                
            }
            if let temp = tasks[i] as? Assignment {
                let componentsNowDay = NSCalendar.currentCalendar().components([.Day], fromDate: currentDate)
                let currentDay = componentsNowDay.day
                
                let componentsDueDateDay = NSCalendar.currentCalendar().components([.Day], fromDate: temp.dueDate)
                let DueDateDay = componentsDueDateDay.day
                
                // day difference = place in col array
                let dayDiff = DueDateDay - currentDay
                
                if dayDiff < 0 {
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