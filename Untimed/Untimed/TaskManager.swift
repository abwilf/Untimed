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
    var workingCellsPerDay = 1440

    
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
    
    
    func isNextSameAsThis (row: Int, col: Int) -> Bool {
        if row > 0 && row < MINS_IN_DAY - 1 || row == 0 {
            if calendarArray[row][col] == calendarArray[row + 1][col] {
                return true
            }
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
    
    func clearCalArray() {
        // create free object to assign in clearCalArray
        let freeObj = Free()
        // starting from the first cell of today to the end of the array
        for var i = 0; i < 28; ++i {
            for var j = 0; j < cellsPerDay; ++j {
                self.calendarArray[j][i] = freeObj
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
        
        // initialize hoursLeftToAllocate of all elements to numBlocksNeeded - numBlocksCompleted
        for var j = 0; j < orderedAssignmentArray.count; ++j {
            orderedAssignmentArray[j].numBlocksLeftToAllocate =
                Int(orderedAssignmentArray[j].numBlocksNeeded) -
                orderedAssignmentArray[j].numBlocksCompleted
        }
        
        // find free hours before due date for all assignments in orderedArray
        for var i = 0; i < orderedAssignmentArray.count; ++i {
            let assignment = orderedAssignmentArray[i]
            orderedAssignmentArray[i].numFreeBlocksBeforeDueDate =
                calcFreeTimeBeforeDueDate(assignment)
        }
        
        // sort by urgency, which is based on hoursLeft and freehoursbeforeduedate
        orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
    }
       func allocateTime() {
        // setCellsPerDay()
        
        // clear out past tasks in task list
        deletePastTasks()
        
        // make all future spots in cal array Free before allocating again from tasks list
        clearCalArray()
        
        // put appts and free time in
        allocateAppts()
        
        // allocate Assignments
        allocateAssignments()
    }
    
    func allocateAppts() {
        // use in both allocations
        var apptDayCoordinate: Int = 0
        // iterate through tasks array looking for appointments
        for var i = 0; i < self.tasks.count; ++i {
            // if object is an appointment, assign to calendarArray
            if let appt = self.tasks[i] as? Appointment {
                apptDayCoordinate = nsDateInCalFormat(appt.startTime).dayCoordinate
                let startTimeInMinCoordinates = nsDateInCalFormat(appt.startTime).minuteCoordinate
                let endTimeInMinCoordinates = nsDateInCalFormat(appt.endTime).minuteCoordinate
                
                // allocate
                for var j = startTimeInMinCoordinates; j < endTimeInMinCoordinates; ++j {
                    self.calendarArray[j][apptDayCoordinate] = appt
                }
            }
        }
    }

    
    
    func allocateAssignments() {
        // make an assignments only array and order it by urgency (based on hoursleft)
        createOrderedArray()
        
        // if there are no assignments to allocate, kick out
        if orderedAssignmentArray.isEmpty {
            return
        }
            
        // otherwise, allocate assignments
        else {
            // variables for right now
            let currentDate = NSDate()
            let currentDateInCal = nsDateInCalFormat(currentDate)
            
            // variables for allocation
            var day = currentDateInCal.dayCoordinate
            var minute = currentDateInCal.minuteCoordinate
            
            // if not enough time to complete most urgent assignment before due date, make b.lockslefttoallocate = amountofFreeTime (so you use up all your time on the assignment)
            let mostUrgentAssn = orderedAssignmentArray[0]
            if mostUrgentAssn.numBlocksLeftToAllocate > mostUrgentAssn.numFreeBlocksBeforeDueDate {
                mostUrgentAssn.numBlocksLeftToAllocate = mostUrgentAssn.numFreeBlocksBeforeDueDate
            }
            
            // allocate
            while mostUrgentAssn.numBlocksLeftToAllocate > 0 {
                // put one block of most urgent in at first available spot starting now
                let temp = putBlockInCalArrayAtFirstFreeSpot(mostUrgentAssn, dayIn: day, minuteIn: minute)
                day = temp.dayOut
                minute = temp.minuteOut
                
                // decrement numBlocksLeftToAllocate of most urgent
                mostUrgentAssn.numBlocksLeftToAllocate -= 1
                
                // re-sort by urgency
                orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
            }
            return
        }
    }
    
    
    func isBlockFree(minIn: Int, dIn: Int) -> Bool {
        // if 15 minutes in a row are free (1 block)
        var count = 0
        for var i = minIn; i < minIn + WORKING_INTERVAL_SIZE; ++i {
            if calendarArray[minIn][dIn].title == "Unnamed Task" &&  minIn + WORKING_INTERVAL_SIZE < workingCellsPerDay && isNextSameAsThis(i, col: dIn) {
                    count += 1
            }
        }
        
        if count == 15 {
            return true
        }
            
        else {
            return false
        }
    }
    
    
    func putBlockInCalArrayAtFirstFreeSpot(assg: Assignment, dayIn: Int, minuteIn: Int) -> (dayOut: Int, minuteOut: Int) {
        var dayOut = 0
        var minuteOut = 0
        
        // if not enough time to allocate before working hours are up, switch to tomorrow
        if minuteIn + 15 > workingCellsPerDay {
            minuteOut = 0
            dayOut = dayIn + 1
            return (dayOut, minuteOut)
        }
        
        var j = 0

        // iterate through today
        for var i = minuteIn; i < workingCellsPerDay - WORKING_INTERVAL_SIZE; ++i {
            // if there's a block available from this moment on (this ever increasing moment starting at minuteIn)
            if isBlockFree(i, dIn: dayIn)  {
                // allocate to it (the next 15 cells)
                for j = i; j < i + WORKING_INTERVAL_SIZE; ++j {
                    // safeguard
                    if let _ = calendarArray[j][dayIn] as? Assignment {
                        // print error message to developer because cal array should have been wiped
                        print("ERROR! Calendar array was not properly cleared, or this allocation did not start at the correct spot (one after the previous slot was allocated to)")
                    }
                    calendarArray[j][dayIn] = assg
                }
                // update minuteOut
                minuteOut = j
                return (dayOut, minuteOut)
            }
        }
        return (dayOut, minuteOut)
    }
    
    init () {
        // also initializes member variables (tasks array)
        loadFromDisc()
        allocateTime()
    }
}