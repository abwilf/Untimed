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
    
    // calendar array = 2d array of MINS_IN_DAY (rows) by 365 days (cols)
    // FIXME: change 28 to DAYS_IN_YEAR days everywhere
    var calendarArray: [[Task]] = Array(count: 1440,
                                        repeatedValue: Array(count: 28, repeatedValue: Free()))
    
    let HOURS_IN_DAY = 12
    let MINS_IN_HOUR = 60
    
    // 24 hrs * 60 mins in an hour (excluding midnight of the following day)
    let MINS_IN_DAY = 1440
    let DAYS_IN_YEAR = 365
    
    // 15 min intervals
    let WORKING_INTERVAL_SIZE = 15
    
    // let = mins in day for now
    // FIXME: this should vary with the user inputted size
    var cellsPerDay = 1440
    
    // FIXME: this is currently set at 8 am to 8 pm.  change to first working minute, and last working minute, make sure they're at midnight and 11:59 (1439)
    let firstWorkingMinute = 480
    let lastWorkingMinute = 1200
    
    // create variables to order array later
    var unfilteredArray: [Task] = Array(count: 40, repeatedValue: Free())
    var assignmentArray = [Assignment]()
    var orderedAssignmentArray = [Assignment]()
    
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
    
    // returns appropriate calendar coordinates
    func nsDateInCalFormat(dateIn: NSDate) ->
        (dayCoordinate: Int, minuteCoordinate: Int) {
            // declare variable we'll need to compare with dateIn
            let currentDate = NSDate()
            
            // converting from NSCal to Integer forms
            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Minute, .Month, .Year]
            
            let currentDateComponents = NSCalendar.currentCalendar().components(unitFlags,
                                                                                fromDate: currentDate)
            let dueDateComponents = NSCalendar.currentCalendar().components(unitFlags,
                                                                            fromDate: dateIn)
            
            // finding day values to get dayCoordinate
            let dueDateDay = dueDateComponents.day
            let currentDay = currentDateComponents.day
            
            // column location in array
            let dayCoordinate = dueDateDay - currentDay
            
            // finding minute coordinate.  0 is midnight of today, 1439 is 11:59 pm
            let minuteCoordinate = (dueDateComponents.hour * MINS_IN_HOUR) + dueDateComponents.minute
            return (dayCoordinate, minuteCoordinate)
    }
    
    
    
    func numFreeBlocksInSameDayInterval (minuteCoordinate1In: Int, minuteCoordinate2In: Int, dayCoordinateIn: Int) -> Int {
        var numFreeBlocks: Int = 0
        var count = 0
        
        for var i = minuteCoordinate1In; i < minuteCoordinate2In; ++i {
            if let _ = calendarArray[i][dayCoordinateIn] as? Free {
                count += 1
            }
                
            else {
                count = 0
            }
            
            // this code makes sure the minutes are consecutive
            if count == 15 {
                numFreeBlocks += 1
                count = 0
            }
        }
        
        return numFreeBlocks
    }
    
    func clearFutureCalArray() {
        
        // create free object to assign
        let freeObj = Free()
        
        // clear calendar array of all assignments for the rest of today
        let rightNow = NSDate()
        let rightNowMinute = nsDateInCalFormat(rightNow).minuteCoordinate
        
        for var i = rightNowMinute; i < MINS_IN_DAY; ++i {
            calendarArray[i][0] = freeObj
        }
        
        // clear for every day afterwards
        // FIXME: 28
        for var j = 1; j < 28; ++j {
            for var i = 0; i < MINS_IN_DAY; ++i {
                calendarArray[i][j] = freeObj
            }
        }
    }
    
    // return number of free 15 minute blocks before it's due
    func calcFreeTimeBeforeDueDate (assignmentIn: Assignment) -> Int {
        // variable that will store amount of free 15 minute blocks before due date
        var numBlocks = 0
        
        // find due date coordinates
        let dueDateDayCoordinate = nsDateInCalFormat(assignmentIn.dueDate).dayCoordinate
        let dueDateMinuteCoordinate = nsDateInCalFormat(assignmentIn.dueDate).minuteCoordinate
        
        // find current coordinates
        let rightNow = NSDate()
        let rightNowDayCoordinate = nsDateInCalFormat(rightNow).dayCoordinate
        let rightNowMinuteCoordinate = nsDateInCalFormat(rightNow).minuteCoordinate
        
        // compare day coordinates
        let dayDiff = dueDateDayCoordinate - rightNowDayCoordinate
        
        // if it's today
        if dayDiff == 0 {
            // if dueDate is more than a working block's time from now, and there's an opportunity for at least one block before lastWorkingMinute
            // FIXME: watch out for the <=, need to ask keenan if this is right
            if dueDateMinuteCoordinate <= lastWorkingMinute - WORKING_INTERVAL_SIZE && dueDateMinuteCoordinate >= rightNowMinuteCoordinate + WORKING_INTERVAL_SIZE {
                numBlocks = numFreeBlocksInSameDayInterval(rightNowMinuteCoordinate, minuteCoordinate2In: dueDateMinuteCoordinate, dayCoordinateIn: 0)
            }
        }
            
            // if it's some day in the future
        else {
            // iterate through today from right now until lastworkingminute
            numBlocks = numFreeBlocksInSameDayInterval(rightNowMinuteCoordinate, minuteCoordinate2In: lastWorkingMinute, dayCoordinateIn: 0)
            
            // iterate through all minutes of days that aren't today (0) or dueDateDay and add to numBlocks
            for var j = 1; j < dueDateDayCoordinate; ++j {
                numBlocks += numFreeBlocksInSameDayInterval(firstWorkingMinute, minuteCoordinate2In: lastWorkingMinute, dayCoordinateIn: j)
            }
            
            // on the due date, iterate from firstworkingminute to dueDateMinuteCoordinate
            numBlocks += numFreeBlocksInSameDayInterval(firstWorkingMinute, minuteCoordinate2In: dueDateMinuteCoordinate, dayCoordinateIn: dueDateDayCoordinate)
        }
        return numBlocks
    }
    
    
    func deletePastTasks() {
        for var i = 0; i < tasks.count; ++i {
            // find current coordinates
            let rightNow = NSDate()
            let rightNowDayCoordinate = nsDateInCalFormat(rightNow).dayCoordinate
            let rightNowMinuteCoordinate = nsDateInCalFormat(rightNow).minuteCoordinate
            
            // if the task is an appointment
            if let temp = tasks[i] as? Appointment {
                // if the appointment happened before today, delete it
                let apptDay = nsDateInCalFormat(temp.endTime).dayCoordinate
                if apptDay - rightNowDayCoordinate < 0 {
                    deleteTaskAtIndex(i)
                }
            }
            
            // if the task is an assignment
            if let temp = tasks[i] as? Assignment {
                // if the assignment was due before right now, delete it
                let dueDateDay = nsDateInCalFormat(temp.dueDate).dayCoordinate
                let dueDateTime = nsDateInCalFormat(temp.dueDate).minuteCoordinate
                
                // if the assignment was due before today, delete it
                let dayDiff = dueDateDay - rightNowDayCoordinate
                if dayDiff < 0 {
                    deleteTaskAtIndex(i)
                }
                
                // if the assignment was due earlier today, delete it
                if dayDiff == 0 && dueDateTime < rightNowMinuteCoordinate {
                    deleteTaskAtIndex(i)
                }
            }
        }
    }
    
    
    private func createOrderedArray() {
        
        // turn tasks array  into array of Assignments
        unfilteredArray = tasks
        assignmentArray = unfilteredArray.filter(isAssignment) as! [Assignment]
        orderedAssignmentArray = assignmentArray
        
        // initialize hoursLeftToAllocate of all elements to timeNeeded - timeCompleted
        for var j = 0; j < orderedAssignmentArray.count; ++j {
            orderedAssignmentArray[j].hoursLeftToAllocate =
                Int(orderedAssignmentArray[j].timeNeeded) -
                orderedAssignmentArray[j].timeCompleted
        }
        
        // find free hours before due date for all assignments in orderedArray
        for var i = 0; i < orderedAssignmentArray.count; ++i {
            let assignment = orderedAssignmentArray[i]
            orderedAssignmentArray[i].amountOfFreeHoursBeforeDueDate =
                calcFreeTimeBeforeDueDate(assignment)
        }
        
        // sort by urgency, which is based on hoursLeft and freehoursbeforeduedate
        orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
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
            
            // FIXME: use nsDateInCalFormat and get rid of this junk
            
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
                // FIXME: replace hourIn with minuteLocationIn
                let temp =
                    // FIXME: alter this code to only allocate if 15 minutes free
                    putAssgInCalArrayAtFirstFreeOrAssignmentSpot(orderedAssignmentArray[0], day: dayIn, hour: hourIn)
                dayIn = temp.dayOut
                hourIn = temp.hourOut
                
                // decrement hoursLeft of most urgent
                // FIXME: change to -= 15 minutes
                orderedAssignmentArray[0].hoursLeftToAllocate -= 1
                // sort by urgency
                orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
            }
            return
        }
    }
    
    func allocateTime() {
        //setCellsPerDay()
        
        // clear out past tasks in task list
        deletePastTasks()
        
        // clear out all future spots in cal array before allocating again from tasks list
        clearFutureCalArray()
        
        // put appts and free time in
        allocateApptsAndFreeTime()
        // allocate Assignments
        allocateAssignments()
    }
    
    func allocateApptsAndFreeTime() {
        
        let currentDate = NSDate()
        for var i = 0; i < self.tasks.count; ++i {
            
            // part I: if object is an appointment, assign to calendarArray
            if let appt = self.tasks[i] as? Appointment {
                
                // FIXME: use nsDateInCalFormat and get rid of this junk {
                
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
                
                // }
                
                // day difference = location in calendar array
                let dayDiffApptAndNow = apptDay - currentDay
                
                // if appt is before today, delete (though minimum constraint should stop the user from doing this, this is a good backup)
                if dayDiffApptAndNow < 0 {
                    deleteTaskAtIndex(i)
                }
                
                // FIXME: get rid of this rounding crap
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
            // FIXME: MAGIC NUMBER.  SEARCH ALL 28's to find them.  run it through an online magic number finder too - Matt's annoying style grader
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
    
    init () {
        // also initializes member variables (tasks array)
        loadFromDisc()
        allocateTime()
    }
}