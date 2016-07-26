//
//  TaskManager.swift
//  Untimed
//
//  Created by Alex Wilf on 3/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class TaskManager: NSObject, NSCopying {
    // empty array of tasks
    var tasks: [Task] = []
    
    // calendar array = 2d array of MINS_IN_DAY (rows) by 365 days (cols)
    // FIXME: change 28 to DAYS_IN_YEAR days everywhere
    var calendarArray: [[Task]] = Array(count: 1440,
                                        repeatedValue: Array(count: 28, repeatedValue: Free()))
    
    let HOURS_IN_DAY = 12
    let MINS_IN_HOUR = 60
    let MINS_IN_DAY = 1440
    let DAYS_IN_YEAR = 365
    let MONTHS_IN_YEAR = 12
    
    // 15 min intervals
    let WORKING_INTERVAL_SIZE = 15
    
    // let = mins in day for now
    var cellsPerDay = 1440
    
    // FIXME: this is currently set at 8 am to 8 pm.  change to first working minute, 
    // and last working minute, make sure they're at midnight and 11:59 (1439)
    var firstWorkingMinute = 480
    var lastWorkingMinute = 1200
    var workingCellsPerDay = 0
    func setWorkingCellsPerDay() {
        workingCellsPerDay = lastWorkingMinute - firstWorkingMinute
    }
    
    /*
     func setLastWorkingMinute() {
     lastWorkingMinute -= 1
     }
     
     */
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = TaskManager()
        return copy
    }
    
    
    func calArrayDescriptionAtIndex(min: Int, day: Int) {
        print ("\(calendarArray[min][day].title)")
    }
    
    func tasksDescription() {
        for i in 0..<tasks.count {
            print ("\(tasks[i].title)\n")
        }
    }
    
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
        if row >= 0 && row < MINS_IN_DAY - 1 {
            if calendarArray[row][col] == calendarArray[row + 1][col] {
                return true
            }
        }
        
        if let _ = calendarArray[row][col] as? Free {
            if let _ = calendarArray[row + 1][col] as? Free {
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
            
            let currentDate = NSDate()
            
            // converting from NSCal to Integer forms
            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Minute, .Month, .Year]
            
            let currentDateComponents = NSCalendar.currentCalendar().components(unitFlags,
                                                                                fromDate: currentDate)
            let dueDateComponents = NSCalendar.currentCalendar().components(unitFlags,
                                                                            fromDate: dateIn)
            
            // finding minute coordinate.  0 is midnight of today, 1439 is 11:59 pm
            let minuteCoordinate = (dueDateComponents.hour * 60) + dueDateComponents.minute
            
            // finding dayCoordinate first by finding day values
            let dueDateDay = dueDateComponents.day
            let currentDay = currentDateComponents.day
            
            // finding month values
            let dueDateMonth = dueDateComponents.month
            let currentMonth = currentDateComponents.month
            
            // finding year values
            let dueDateYear = dueDateComponents.year
            let currentYear = currentDateComponents.year
            
            // calculate column location in array
            var dayCoordinate = 0
            
            // if year and month are the same, calculate only based on day coordinates
            if dueDateYear == currentYear && dueDateMonth == currentMonth {
                dayCoordinate = dueDateDay - currentDay
            }
                
                // if month is greater and year is same
            else if dueDateMonth > currentMonth && dueDateYear == currentYear {
                // from here to end of this month
                let numDaysCurrentMonth = numDaysInMonth(currentMonth)
                dayCoordinate += numDaysCurrentMonth - currentDay
                
                // adding in days from all included months (need to check all months codes)
                for i in 0..<MONTHS_IN_YEAR {
                    if doesIncludeSameYear(currentMonth, endMonth: dueDateMonth, questionableMonth: i) {
                        dayCoordinate += numDaysInMonth(i)
                    }
                }
                
                // add in days for dueDateMonth
                dayCoordinate += dueDateDay
            }
                
                // if it's next calendar year, but earlier month (november 2015 - jan 2016)
            else if dueDateMonth <= currentMonth && dueDateYear == currentYear + 1 {
                // from here to end of this month
                let numDaysCurrentMonth = numDaysInMonth(currentMonth)
                dayCoordinate += numDaysCurrentMonth - currentDay
                
                // adding in days from all included months (need to check all months codes)
                for i in 0..<MONTHS_IN_YEAR {
                    if doesIncludeNextYear(currentMonth, endMonth: dueDateMonth, questionableMonth: i) {
                        dayCoordinate += numDaysInMonth(i)
                    }
                }
                
                // add in days for dueDateMonth
                dayCoordinate += dueDateDay
            }
                
                // if it's in the past
            else if dueDateYear < currentYear {
                dayCoordinate = -1
            }
                
            else if dueDateMonth < currentMonth && dueDateYear == currentYear {
                dayCoordinate = -1
            }
                
            else if dueDateMonth == currentMonth && dueDateYear == currentYear && dueDateDay < currentDay {
                dayCoordinate = -1
            }
            
            return (dayCoordinate, minuteCoordinate)
    }
    
    func doesIncludeNextYear (startMonth: Int, endMonth: Int, questionableMonth: Int) -> Bool {
        // if greater than start, but lsess than end
        if (questionableMonth > startMonth && questionableMonth <= MONTHS_IN_YEAR) ||
            (questionableMonth >= 1 && questionableMonth < endMonth) {
            return true
        }
        else {
            return false
        }
    }
    
    
    func numDaysInMonth(monthIn: Int) -> Int {
        if monthIn == 1 || monthIn == 3 || monthIn == 5 || monthIn == 7
            || monthIn == 8 || monthIn == 10 || monthIn == 12 {
            return 31
        }
            
        else if monthIn == 9 || monthIn == 4 || monthIn == 6 || monthIn == 11 {
            return 30
        }
            
        else if monthIn == 2 {
            return 28
        }
            
        else {
            print ("ERROR! monthIn is incorrect in nsDateInCal function.")
            return 0
        }
        
    }
    
    func doesIncludeSameYear(startMonth: Int,
                             endMonth: Int,
                             questionableMonth: Int) -> Bool {
        // if between the two
        if startMonth < questionableMonth && endMonth > questionableMonth {
            return true
        }
            
        else {
            return false
        }
    }
    
    func numFreeBlocksInSameDayInterval (minuteCoordinate1In: Int,
                                         minuteCoordinate2In: Int,
                                         dayCoordinateIn: Int) -> Int {
        var numFreeBlocks: Int = 0
        var count = 0
        
        var i = minuteCoordinate1In
        while i < minuteCoordinate2In {
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
            i += 1
        }
        
        return numFreeBlocks
    }
    
    func clearCalArray() {
        
        // starting from the first cell of today to the end of the array
        for i in 0..<28 {
            for j in 0..<cellsPerDay {
                // create free object to assign in clearCalArray
                let freeObj = Free()
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
            // if dueDate is more than a working block's time from now, and 
            // there's an opportunity for at least one block before lastWorkingMinute
            // FIXME: watch out for the <=, need to ask keenan if this is right
            if dueDateMinuteCoordinate >= rightNowMinuteCoordinate + WORKING_INTERVAL_SIZE {
                numBlocks = numFreeBlocksInSameDayInterval(rightNowMinuteCoordinate,
                                                           minuteCoordinate2In: dueDateMinuteCoordinate,
                                                           dayCoordinateIn: 0)
            }
        }
            
            // if it's some day in the future
        else {
            // iterate through today from right now until lastworkingminute
            numBlocks = numFreeBlocksInSameDayInterval(rightNowMinuteCoordinate,
                                                       minuteCoordinate2In: lastWorkingMinute,
                                                       dayCoordinateIn: 0)
            
            // iterate through all minutes of days that aren't today (0) or dueDateDay and add to numBlocks
            for j in 1..<dueDateDayCoordinate {
                numBlocks += numFreeBlocksInSameDayInterval(firstWorkingMinute,
                                                            minuteCoordinate2In: lastWorkingMinute,
                                                            dayCoordinateIn: j)
            }
            
            // on the due date, iterate from firstworkingminute to dueDateMinuteCoordinate
            numBlocks += numFreeBlocksInSameDayInterval(firstWorkingMinute,
                                                        minuteCoordinate2In: dueDateMinuteCoordinate,
                                                        dayCoordinateIn: dueDateDayCoordinate)
        }
        return numBlocks
    }
    
    func deletePastTasks() {
        for i in 0..<tasks.count {
            // if the task is an appointment
            if let temp = tasks[i] as? Appointment {
                // if the appointment happened before today, delete it
                let apptDay = nsDateInCalFormat(temp.endTime).dayCoordinate
                if apptDay < 0 {
                    deleteTaskAtIndex(i)
                }
            }
            
            // if the task is an assignment
            if let temp = tasks[i] as? Assignment {
                // find coordinates
                let rightNow = NSDate()
                let rightNowMinuteCoordinate = nsDateInCalFormat(rightNow).minuteCoordinate
                let dueDateDay = nsDateInCalFormat(temp.dueDate).dayCoordinate
                let dueDateTime = nsDateInCalFormat(temp.dueDate).minuteCoordinate
                
                // if the assignment was due before today, delete it
                if dueDateDay < 0 {
                    deleteTaskAtIndex(i)
                }
                
                // if the assignment was due earlier today, delete it
                if dueDateDay == 0 && dueDateTime < rightNowMinuteCoordinate + WORKING_INTERVAL_SIZE {
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
        for j in 0..<orderedAssignmentArray.count {
            orderedAssignmentArray[j].numBlocksLeftToAllocate =
                Int(orderedAssignmentArray[j].numBlocksNeeded) -
                orderedAssignmentArray[j].numBlocksCompleted
        }
        
        // find free hours before due date for all assignments in orderedArray
        for i in 0..<orderedAssignmentArray.count {
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
        for i in 0..<self.tasks.count {
            // if object is an appointment, assign to calendarArray
            if let appt = self.tasks[i] as? Appointment {
                apptDayCoordinate = nsDateInCalFormat(appt.startTime).dayCoordinate
                let startTimeInMinCoordinates = nsDateInCalFormat(appt.startTime).minuteCoordinate
                let endTimeInMinCoordinates = nsDateInCalFormat(appt.endTime).minuteCoordinate
                
                // allocate
                for j in startTimeInMinCoordinates..<endTimeInMinCoordinates {
                    self.calendarArray[j][apptDayCoordinate] = appt
                }
            }
        }
    }
    
    
    
    func allocateAssignments() {
        // setting based on user input (decreasing working minute by one b/c of dailysched format)
        setWorkingCellsPerDay()
        // setLastWorkingMinute()
        
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
            
            // if not enough time to complete most urgent assignment before due date, 
            // make blockslefttoallocate = amountofFreeTime (so you use up all your time on the assignment)
            var mostUrgentAssn = orderedAssignmentArray[0]
            if mostUrgentAssn.numBlocksLeftToAllocate > mostUrgentAssn.numFreeBlocksBeforeDueDate {
                mostUrgentAssn.numBlocksLeftToAllocate = mostUrgentAssn.numFreeBlocksBeforeDueDate
            }
            
            // allocate
            while mostUrgentAssn.numBlocksLeftToAllocate > 0 {
                // put one block of most urgent in at first available spot starting now
                let temp = putBlockInCalArrayAtFirstFreeSpotToday(mostUrgentAssn,
                                                                  dayIn: day,
                                                                  minuteIn: minute)
                
                // if it's still allocating to today
                if day == temp.dayOut {
                    // decrement numBlocksLeftToAllocate of most urgent
                    mostUrgentAssn.numBlocksLeftToAllocate -= 1
                    
                    // re-sort by urgency, restating mostUrgentAssn so it updates
                    orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
                    mostUrgentAssn = orderedAssignmentArray[0]
                }
                    
                    // if needs to switch to tomorrow, don't decrement because it didn't allocate
                else {
                    day = temp.dayOut
                }
                
                // either way, assign minute
                minute = temp.minuteOut
            }
            return
        }
    }
    
    func putBlockInCalArrayAtFirstFreeSpotToday(assg: Assignment, dayIn: Int,
                                                minuteIn: Int) -> (dayOut: Int, minuteOut: Int) {
        var dayOut = 0
        var minuteOut = 0
        
        // if not enough time to allocate before working hours are up, switch to tomorrow
        if minuteIn + WORKING_INTERVAL_SIZE > lastWorkingMinute {
            minuteOut = firstWorkingMinute
            dayOut = dayIn + 1
            return (dayOut, minuteOut)
        }
        
        var j = 0
        
        // iterate through the day to where the last working block starts
        for i in minuteIn..<lastWorkingMinute - WORKING_INTERVAL_SIZE + 1 {
            // if there's a block available from this moment on (this ever increasing moment starting at minuteIn)
            if isBlockFree(i, dIn: dayIn)  {
                // allocate to it (the next 15 cells)
                j = i
                while (j < i + WORKING_INTERVAL_SIZE) {
                    // safeguard
                    if let _ = calendarArray[j][dayIn] as? Assignment {
                        // print error message to developer because cal array should have been wiped
                        print("ERROR! Calendar array was not properly cleared, or this allocation did not start at the correct spot (one after the previous slot was allocated to)")
                    }
                    calendarArray[j][dayIn] = assg
                    j += 1
                }
                
                // update minuteOut
                minuteOut = j
                dayOut = dayIn
                return (dayOut, minuteOut)
            }
        }
        return (dayOut, minuteOut)
    }
    
    func isBlockFree(minIn: Int, dIn: Int) -> Bool {
        // if 15 minutes in a row are free (1 block)
        var count = 0
        if minIn >= firstWorkingMinute {
            for i in minIn..<(minIn + WORKING_INTERVAL_SIZE - 1) {
                if calendarArray[minIn][dIn].title == "Unnamed Task" && isNextSameAsThis(i, col: dIn) {
                    count += 1
                }
            }
            
            // is minus one because it only looks at whether the next one is the same.  Doesn't count for this one.
            if count == WORKING_INTERVAL_SIZE - 1 {
                return true
            }
                
            else {
                return false
            }
        }
        
        return false
    }
    
    
    override init () {
        // also initializes member variables (tasks array)
        super.init()
        self.loadFromDisc()
        self.allocateTime()
    }
}