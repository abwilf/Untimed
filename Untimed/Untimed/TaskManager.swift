//
//  TaskManager.swift
//  Untimed
//
//  Created by Alex Wilf on 3/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        // 2 digit hour:2 digit minute
        dateStringFormatter.dateFormat = "HH:mm"
        dateStringFormatter.locale = NSLocale.currentLocale()
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
    
    func getTimeValForComparison() -> Int {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HHmm"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let stringVal = formatter.stringFromDate(self)
        let intVal = Int(stringVal)
        return intVal! //Int(formatter.stringFromDate(self))!
    }
    
    func calendarDayIndex() -> Int {
        let calendar = NSCalendar.currentCalendar()
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: NSDate())
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: self)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
}

class TaskManager: NSObject, NSCopying {
    // empty array of tasks
//    var tasks: [Task] = []
    var classArray: [Class] = []
    var appointmentArray: [Appointment] = []
    var focusTasksArr: [Task] = []
    var selectedDate: NSDate = NSDate()
    
    // calendar array = 2d array of MINS_IN_DAY (rows) by 365 days (cols)
    // FIXME: change 28 to DAYS_IN_YEAR days everywhere
    
    // 28 rows (days) x 0 objects to start, objects will be appended to each column as needed
    var calendarArray: [[Task]] = Array(count: 28,
                                        repeatedValue: Array(count: 0, repeatedValue: Free()))
    
    let HOURS_IN_DAY = 12
    let MINS_IN_HOUR = 60
    let MINS_IN_DAY = 1440
    let DAYS_IN_YEAR = 365
    let MONTHS_IN_YEAR = 12
    
    // 15 min intervals
    let WORKING_INTERVAL_SIZE = 15
    
    // let = mins in day for now
    var cellsPerDay = 1440
    
    // in dsCalFormat; default is 8 am to 7 pm
//    var firstWorkingMinute = 480
//    var lastWorkingMinute = 1140
    
    var settingsArray: [NSDate] = []
    
    func setSettingsArray() {
        // clear
        settingsArray = []
        
        // refill
        settingsArray += [firstWorkingHour]
        
        settingsArray += [lastWorkingHour]
}
    
    var workingCellsPerDay = 0
//    func setWorkingCellsPerDay() {
//        workingCellsPerDay = lastWorkingMinute - firstWorkingMinute
//    }
    
    var firstWorkingHour = NSDate(dateString: "08:00")
    var lastWorkingHour = NSDate(dateString: "23:00")
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = TaskManager()
        return copy
    }
    
//    func findTasksIndexForTask(taskIn: Task) -> Int {
//        for i in 0..<tasks.count {
//            if (taskIn == tasks[i]) {
//                return i
//            }
//        }
//        // you know something's wrong
//        assert(false, "Task not found")
//        return -1
//    }
    
    func addClass(classIn: Class) {
        classArray += [classIn]
    }
    
    func addProject(projIn: Project, forClass classIn: Class) {
        classIn.projAndAssns.append(projIn)
    }
    
    func addAssignment(asgtIn: Assignment, forClass classIn: Class) {
        classIn.projAndAssns.append(asgtIn)
    }
    
    func addProjectTask(projTaskIn: ProjectTask, forProject projIn: Project) {
        projIn.projTaskArr.append(projTaskIn)
    }
    
    func addAppointment(apptIn: Appointment) {
        appointmentArray.append(apptIn)
    }
    
    func deleteClass(classIn: Class) {
        for i in 0..<classArray.count {
            if classArray[i] == classIn {
                classArray.removeAtIndex(i)
                return
            }
        }
    }
    
    func deleteClassAtIndex(classIndex index: Int) {
        classArray.removeAtIndex(index)
    }
    
    func deleteProject(projIn: Project, forClass classIn: Class) {
        for i in 0..<classIn.projAndAssns.count {
            if classIn.projAndAssns[i] == projIn {
                classIn.projAndAssns.removeAtIndex(i)
                return
            }
        }
    }
    

    
    func deleteAssignment(asgtIn: Assignment, forClass classIn: Class) {
        for i in 0..<classIn.projAndAssns.count {
            if classIn.projAndAssns[i] == asgtIn {
                classIn.projAndAssns.removeAtIndex(i)
                return
            }
        }
    }
    
    func deleteProjectOrAssignmentAtIndex(index index: Int, forClass classIn: Class) {
        classIn.projAndAssns.removeAtIndex(index)
    }

    
    func deleteProjectTask(projTaskIn: ProjectTask, forProject projIn: Project) {
        for i in 0..<projIn.projTaskArr.count {
            if projIn.projTaskArr[i] == projTaskIn {
                projIn.projTaskArr.removeAtIndex(i)
                return
            }
        }
    }
    
    func deleteProjectTaskAtIndex(projTaskIndex index: Int, forProj projIn: Project) {
        projIn.projTaskArr.removeAtIndex(index)
    }
    
    func deleteAppointment(apptIn: Appointment) {
        for i in 0..<appointmentArray.count {
            if appointmentArray[i] == apptIn {
                appointmentArray.removeAtIndex(i)
                return
            }
        }
    }
//    func findProjAndAssnIndex(classIndexTasksIn: Int, taskIn: Task) -> Int {
//        // go to tasks list at classIndexIn
//        if let clas = tasks[classIndexTasksIn] as? Class {
//            // find taskIn within projAndAssn arr
//            for i in 0..<clas.projAndAssns.count {
//                if taskIn == clas.projAndAssns[i] {
//                    return i
//                }
//            }
//        }
//        assert(false, "Project/assignment not found")
//        return -1
//    }
    
//    func findProjTaskIndexInProj(projectInTasksIndexIn: Int, taskIn: Task) -> Int {
//        // go to tasks list at classIndexIn
//        if let proj = tasks[projectInTasksIndexIn] as? Project {
//            // find taskIn within projTask arr
//            for i in 0..<proj.projTaskArr.count {
//                if taskIn == proj.projTaskArr[i] {
//                    return i
//                }
//            }
//        }
//        assert(false, "Project task not found")
//        return -1
//    }
    
    func calArrayDescriptionAtIndex(min: Int, day: Int) {
        print ("\(calendarArray[min][day].title)")
    }
 
//    func tasksDescription() {
//        for i in 0..<tasks.count {
//            print ("\(tasks[i].title)\n")
//        }
//    }
    
    
//    func createClassArray() {
//        // wipe
//        classArray = []
//        
//        // refill
//        for i in 0..<tasks.count {
//            if let task = tasks[i] as? Class {
//                classArray += [task]
//            }
//        }
//        
//        save()
//    }
    
//    func updateTaskIndexValues() {
//        for i in 0..<tasks.count {
//            tasks[i].tasksIndex = i
//        }
//    }
    
    // create variables to order array later
    var unfilteredArray: [Task] = Array(count: 40, repeatedValue: Free())
    var assignmentArray = [Assignment]()
    var orderedAssignmentArray = [Assignment]()
    
//    func addTask (taskIn: Task) {
//        // add to array
//        tasks += [taskIn]
//        save()
//        allocateTime()
//    }
    
//    func deleteTaskAtIndex (index: Int) {
//        tasks.removeAtIndex(index)
//        save()
//        allocateTime()
//    }
    
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
    
    func createProjOnlyArray() {
        
        // go through projAndAssnArray for all classes and create projOnly array for each
        for j in 0..<classArray.count {
            // wipe for each class
            classArray[j].projOnlyArray = []
            
            // refill
            for i in 0..<classArray[j].projAndAssns.count {
                if let project = classArray[j].projAndAssns[i] as? Project {
                    // note its position in the original array
                    project.indexInProjAndAssnArr = i
                    
                    // add to projOnlyArray
                    classArray[j].projOnlyArray += [project]
                }
            }
        }
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
    
//    // returns appropriate calendar coordinates
//    func nsDateInCalFormat(dateIn: NSDate) ->
//        (dayCoordinate: Int, minuteCoordinate: Int, hourValue: Int, minuteValue: Int) {
//            
//            let currentDate = NSDate()
//            
//            // converting from NSCal to Integer forms
//            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Minute, .Month, .Year]
//            
//            let currentDateComponents = NSCalendar.currentCalendar().components(unitFlags,
//                                                                                fromDate: currentDate)
//            let dueDateComponents = NSCalendar.currentCalendar().components(unitFlags,
//                                                                            fromDate: dateIn)
//            
//            // finding minute coordinate.  0 is midnight of today, 1439 is 11:59 pm
//            let minuteCoordinate = (dueDateComponents.hour * 60) + dueDateComponents.minute
//            
//            let hourValue = dueDateComponents.hour
//            
//            let minuteValue = dueDateComponents.minute
//            
//            // finding dayCoordinate first by finding day values
//            let dueDateDay = dueDateComponents.day
//            let currentDay = currentDateComponents.day
//            
//            // finding month values
//            let dueDateMonth = dueDateComponents.month
//            let currentMonth = currentDateComponents.month
//            
//            // finding year values
//            let dueDateYear = dueDateComponents.year
//            let currentYear = currentDateComponents.year
//            
//            // calculate column location in array
//            var dayCoordinate = 0
//            
//            // if year and month are the same, calculate only based on day coordinates
//            if dueDateYear == currentYear && dueDateMonth == currentMonth {
//                dayCoordinate = dueDateDay - currentDay
//            }
//                
//                // if month is greater and year is same
//            else if dueDateMonth > currentMonth && dueDateYear == currentYear {
//                // from here to end of this month
//                let numDaysCurrentMonth = numDaysInMonth(currentMonth)
//                dayCoordinate += numDaysCurrentMonth - currentDay
//                
//                // adding in days from all included months (need to check all months codes)
//                for i in 0..<MONTHS_IN_YEAR {
//                    if doesIncludeSameYear(currentMonth, endMonth: dueDateMonth, questionableMonth: i) {
//                        dayCoordinate += numDaysInMonth(i)
//                    }
//                }
//                
//                // add in days for dueDateMonth
//                dayCoordinate += dueDateDay
//            }
//                
//                // if it's next calendar year, but earlier month (november 2015 - jan 2016)
//            else if dueDateMonth <= currentMonth && dueDateYear == currentYear + 1 {
//                // from here to end of this month
//                let numDaysCurrentMonth = numDaysInMonth(currentMonth)
//                dayCoordinate += numDaysCurrentMonth - currentDay
//                
//                // adding in days from all included months (need to check all months codes)
//                for i in 0..<MONTHS_IN_YEAR {
//                    if doesIncludeNextYear(currentMonth, endMonth: dueDateMonth, questionableMonth: i) {
//                        dayCoordinate += numDaysInMonth(i)
//                    }
//                }
//                
//                // add in days for dueDateMonth
//                dayCoordinate += dueDateDay
//            }
//                
//                // if it's in the past
//            else if dueDateYear < currentYear {
//                dayCoordinate = -1
//            }
//                
//            else if dueDateMonth < currentMonth && dueDateYear == currentYear {
//                dayCoordinate = -1
//            }
//                
//            else if dueDateMonth == currentMonth && dueDateYear == currentYear && dueDateDay < currentDay {
//                dayCoordinate = -1
//            }
//            
//            return (dayCoordinate, minuteCoordinate, hourValue, minuteValue)
//    }
    
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
        
        calendarArray = Array(count: 28, repeatedValue: Array(count: 0, repeatedValue: Free()))
        
//        // starting from the first cell of today to the end of the array
//        for i in 0..<28 {
//            for j in 0..<calendarArray[i].count {
//                // create free object to assign in clearCalArray
//                let freeObj = Free()
//                self.calendarArray[j][i] = freeObj
//            }
//        }
    }
    
    // return number of free 15 minute blocks before it's due
//    func calcFreeTimeBeforeDueDate (assignmentIn: Assignment) -> Int {
//        // variable that will store amount of free 15 minute blocks before due date
//        var numBlocks = 0
//        
//        // find due date coordinates
//        let dueDateDayCoordinate = nsDateInCalFormat(assignmentIn.dueDate).dayCoordinate
//        let dueDateMinuteCoordinate = nsDateInCalFormat(assignmentIn.dueDate).minuteCoordinate
//        
//        // find current coordinates
//        let rightNow = NSDate()
//        let rightNowDayCoordinate = nsDateInCalFormat(rightNow).dayCoordinate
//        let rightNowMinuteCoordinate = nsDateInCalFormat(rightNow).minuteCoordinate
//        
//        // compare day coordinates
//        let dayDiff = dueDateDayCoordinate - rightNowDayCoordinate
//        
//        // if it's today
//        if dayDiff == 0 {
//            // if dueDate is more than a working block's time from now, and 
//            // there's an opportunity for at least one block before lastWorkingMinute
//            // FIXME: watch out for the <=, need to ask keenan if this is right
//            if dueDateMinuteCoordinate >= rightNowMinuteCoordinate + WORKING_INTERVAL_SIZE {
//                numBlocks = numFreeBlocksInSameDayInterval(rightNowMinuteCoordinate,
//                                                           minuteCoordinate2In: dueDateMinuteCoordinate,
//                                                           dayCoordinateIn: 0)
//            }
//        }
//            
//            // if it's some day in the future
//        else {
//            // iterate through today from right now until lastworkingminute
//            numBlocks = numFreeBlocksInSameDayInterval(rightNowMinuteCoordinate,
//                                                       minuteCoordinate2In: lastWorkingMinute,
//                                                       dayCoordinateIn: 0)
//            
//            // iterate through all minutes of days that aren't today (0) or dueDateDay and add to numBlocks
//            for j in 1..<dueDateDayCoordinate {
//                numBlocks += numFreeBlocksInSameDayInterval(firstWorkingMinute,
//                                                            minuteCoordinate2In: lastWorkingMinute,
//                                                            dayCoordinateIn: j)
//            }
//            
//            // on the due date, iterate from firstworkingminute to dueDateMinuteCoordinate
//            numBlocks += numFreeBlocksInSameDayInterval(firstWorkingMinute,
//                                                        minuteCoordinate2In: dueDateMinuteCoordinate,
//                                                        dayCoordinateIn: dueDateDayCoordinate)
//        }
//        return numBlocks
//    }
    
    // for testing
    private func clearClassArray() {
        for _ in classArray {
            classArray.popLast()
        }
        save()
    }
    
    // for testing
    private func clearAppointmentArray() {
        for _ in appointmentArray {
            appointmentArray.popLast()
        }
    }
    
//    func deletePastTasks() {
//        for i in 0..<tasks.count {
//             if the task is an appointment
//            if let temp = tasks[i] as? Appointment {
//                if !temp.doesRepeat {
//                    // if the appointment happened before today, delete it
//                    let apptDay = nsDateInCalFormat(temp.endTime).dayCoordinate
//                    if apptDay < 0 {
//                        deleteTaskAtIndex(i)
//                    }
//                }
//                else {
//                    if temp.endRepeatIndex == 1 {
//                        let endDay = nsDateInCalFormat(temp.endRepeatDate!).dayCoordinate
//                        if endDay < 0 {
//                            deleteTaskAtIndex(i)
//                        }
//                    }
//                    // FIXME: call an update function here that deletes past repetitions and adds a correrrsponding number of repetitions to the end
//                }
//            }
//            
//            // if the task is an assignment
//            if let temp = tasks[i] as? Assignment {
//                // find coordinates
//                let rightNow = NSDate()
//                let rightNowMinuteCoordinate = nsDateInCalFormat(rightNow).minuteCoordinate
//                let dueDateDay = nsDateInCalFormat(temp.dueDate).dayCoordinate
//                let dueDateTime = nsDateInCalFormat(temp.dueDate).minuteCoordinate
//                
//                // if the assignment was due before today, delete it
//                if dueDateDay < 0 {
//                    deleteTaskAtIndex(i)
//                }
//                
//                // if the assignment was due earlier today, delete it
//                if dueDateDay == 0 && dueDateTime < rightNowMinuteCoordinate + WORKING_INTERVAL_SIZE {
//                    deleteTaskAtIndex(i)
//                }
//            }
//        }
//    }
    
//    private func createOrderedArray() {
//        // turn tasks array  into array of Assignments
//        unfilteredArray = tasks
//        assignmentArray = unfilteredArray.filter(isAssignment) as! [Assignment]
//        orderedAssignmentArray = assignmentArray
//        
//        // initialize hoursLeftToAllocate of all elements to numBlocksNeeded - numBlocksCompleted
//        for j in 0..<orderedAssignmentArray.count {
//            orderedAssignmentArray[j].numBlocksLeftToAllocate =
//                Int(orderedAssignmentArray[j].numBlocksNeeded) -
//                orderedAssignmentArray[j].numBlocksCompleted
//        }
//        
//        // find free hours before due date for all assignments in orderedArray
//        for i in 0..<orderedAssignmentArray.count {
//            let assignment = orderedAssignmentArray[i]
//            orderedAssignmentArray[i].numFreeBlocksBeforeDueDate =
//                calcFreeTimeBeforeDueDate(assignment)
//        }
//        
//        // sort by urgency, which is based on hoursLeft and freehoursbeforeduedate
//        orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
//    }

    // FIXME: this may be getting called redundantly
    func allocateTime() {
        // for testing
//        clearClassArray()
        // for testing
//        clearAppointmentArray()
//        save()

        // setCellsPerDay()
        
//        deletePastTasks()
        
        // make all future spots in cal array Free before allocating again from tasks list
        clearCalArray()
        
        
        // put appts in
        allocateAppts()
        
        // updateCalArray()
        
//        allocateWorkingBlocks()
        
        //allocateAssignments()
    }
    
    func updateCalArray() {
        // FIXME: implement
    }
    
    func clearWorkingBlocksAtIndex(dayIndex index: Int) {
        var i = calendarArray[index].count - 1
        while i >= 0 {
            if let _ = calendarArray[index][i] as? WorkingBlock {
                calendarArray[index].removeAtIndex(i)
            }
            i -= 1
        }
    }
    
    func isDate(earlier: NSDate, earlierThan later: NSDate) -> Bool {
        let earlierVal = earlier.getTimeValForComparison()
        let laterVal = later.getTimeValForComparison()
        if earlierVal < laterVal {
            return true
        }
        return false
//        if earlier.compare(later) == NSComparisonResult.OrderedAscending {
//            return true
//        }
//        return false
    }
    
    private func isDate(first: NSDate, sameAs second: NSDate) -> Bool {
        let firstVal = first.getTimeValForComparison()
        let secondVal = second.getTimeValForComparison()
        if firstVal == secondVal {
            return true
        }
        return false
//        if first.compare(second) == NSComparisonResult.OrderedSame {
//            return true
//        }
//        return false
    }
    
    private func firstWorkingBlockInDay(dayIndex i: Int) -> (startTime: NSDate?, endTime: NSDate?, rowIndex: Int?) {
        var startTime: NSDate? = nil
        var endTime: NSDate? = nil
        var rowIndex: Int? = nil
        
        if calendarArray[i].isEmpty {
            startTime = firstWorkingHour
            endTime = lastWorkingHour
            rowIndex = 0
        }
        else if isDate(firstWorkingHour, earlierThan: calendarArray[i][0].startTime) {
            startTime = firstWorkingHour
            endTime = calendarArray[i][0].startTime
            rowIndex = 0
        }
        else {
            for j in 1..<calendarArray[i].count {
                if isDate(calendarArray[i][j].startTime, earlierThan: lastWorkingHour) {
                    if !isDate(calendarArray[i][j].startTime, sameAs: calendarArray[i][j - 1].endTime) {
                        startTime = calendarArray[i][j - 1].endTime
                        endTime = calendarArray[i][j].startTime
                        rowIndex = j
                        break
                    }
                }
                else if isDate(calendarArray[i][j-1].endTime, earlierThan: lastWorkingHour) {
                    startTime = calendarArray[i][j-1].endTime
                    endTime = lastWorkingHour
                    rowIndex = j
                    break
                }
            }
            if isDate((calendarArray[i].last?.endTime)!, earlierThan: lastWorkingHour) {
                startTime = calendarArray[i].last?.endTime
                endTime = lastWorkingHour
                rowIndex = calendarArray[i].endIndex
            }
        }
        
        return (startTime, endTime, rowIndex)
    }
    
    func allocateWorkingBlocksAtIndex(dayIndex dayIndex: Int) {
        var (startTime, endTime, rowIndex) = firstWorkingBlockInDay(dayIndex: dayIndex)
        while (startTime != nil) {
            let workingBlock = WorkingBlock()
            workingBlock.startTime = startTime!
            workingBlock.endTime = endTime!
            calendarArray[dayIndex].insert(workingBlock, atIndex: rowIndex!)
            (startTime, endTime, rowIndex) = firstWorkingBlockInDay(dayIndex: dayIndex)
        }
        //        for j in 0..<28 {
        //            for i in firstWorkingMinute..<lastWorkingMinute {
        //                if let _ = self.calendarArray[i][j] as? Free {
        //
        //                    self.calendarArray[i][j] = WorkingBlock()
        //                }
        //            }
        //        }
    }

    private func allocateApptInCorrectSpot(appt: Appointment, day dayIn: Int) {
        if calendarArray[dayIn].isEmpty {
            calendarArray[dayIn].append(appt)
        }
        else {
            
            for compareTask in calendarArray[dayIn] {
                var rowIndex = 0
                if let _ = compareTask as? Appointment {
                    var compareAppt = calendarArray[dayIn][rowIndex]
                    while appt.startTime.compare(compareAppt.startTime) == NSComparisonResult.OrderedDescending {
                        if rowIndex < calendarArray[dayIn].count {
                            compareAppt = calendarArray[dayIn][rowIndex]
                            rowIndex += 1
                        }
                        else {
                            break
                        }
                    }
                    self.calendarArray[dayIn].insert(appt, atIndex: rowIndex)
                }
                
            }
        }
    }
    
    // FIXME: make this more readable!
    func allocateAppts() {
        clearCalArray()
        // use in both allocations
        var apptDayCoordinate: Int = 0
        // iterate through tasks array looking for appointments
        for i in 0..<self.appointmentArray.count {
            // if object is an appointment, assign to calendarArray
            if let appt = self.appointmentArray[i] as? Appointment {
                apptDayCoordinate = appt.startTime.calendarDayIndex()
//                let startTimeInMinCoordinates = nsDateInCalFormat(appt.startTime).minuteCoordinate
//                let endTimeInMinCoordinates = nsDateInCalFormat(appt.endTime).minuteCoordinate
                
                // skip if it's past
                // FIXME: this might be inefficient, consider restructuring
                if apptDayCoordinate >= 0 {
                    allocateApptInCorrectSpot(appt, day: apptDayCoordinate)
                }
                
                // if appt repeats, allocate those repetions
                if appt.doesRepeat {
                    if appt.repetitions.isEmpty {
                        appt.allocateAppointmentRepetitions()
                    }
                    else {
                         appt.updateRepetitions()
                    }
                    for k in 0..<appt.repetitions.count {
                        let repetition = appt.repetitions[k]
                        apptDayCoordinate = repetition.startTime.calendarDayIndex()
//                        apptDayCoordinate = nsDateInCalFormat(repetition.startTime).dayCoordinate
//                        let startTimeInMinCoordinates = nsDateInCalFormat(repetition.startTime).minuteCoordinate
//                        let endTimeInMinCoordinates = nsDateInCalFormat(repetition.endTime).minuteCoordinate    
                        
                        // FIXME: make this irrelevant by deleting past repetions
                        if apptDayCoordinate >= 0 {
                            assert(false, "/n/n past repetitions should have been removed already /n/n")
                            // allocate
                            allocateApptInCorrectSpot(repetition, day: apptDayCoordinate)
//                            for l in startTimeInMinCoordinates..<endTimeInMinCoordinates {
//                                self.calendarArray[l][apptDayCoordinate] = appt
//                            }
                        }
                    }
                }
            }
        }
    }
    
//    func allocateAssignments() {
//        // setting based on user input (decreasing working minute by one b/c of dailysched format)
//        setWorkingCellsPerDay()
//        // setLastWorkingMinute()
//        
//        // make an assignments only array and order it by urgency (based on hoursleft)
//        createOrderedArray()
//        
//        // if there are no assignments to allocate, kick out
//        if orderedAssignmentArray.isEmpty {
//            return
//        }
//            
//            // otherwise, allocate assignments
//        else {
//            // variables for right now
//            let currentDate = NSDate()
//            let currentDateInCal = nsDateInCalFormat(currentDate)
//            
//            // variables for allocation
//            var day = currentDateInCal.dayCoordinate
//            var minute = currentDateInCal.minuteCoordinate
//            
//            // if not enough time to complete most urgent assignment before due date, 
//            // make blockslefttoallocate = amountofFreeTime (so you use up all your time on the assignment)
//            var mostUrgentAssn = orderedAssignmentArray[0]
//            if mostUrgentAssn.numBlocksLeftToAllocate > mostUrgentAssn.numFreeBlocksBeforeDueDate {
//                mostUrgentAssn.numBlocksLeftToAllocate = mostUrgentAssn.numFreeBlocksBeforeDueDate
//            }
//            
//            // allocate
//            while mostUrgentAssn.numBlocksLeftToAllocate > 0 {
//                // put one block of most urgent in at first available spot starting now
//                let temp = putBlockInCalArrayAtFirstFreeSpotToday(mostUrgentAssn,
//                                                                  dayIn: day,
//                                                                  minuteIn: minute)
//                
//                // if it's still allocating to today
//                if day == temp.dayOut {
//                    // decrement numBlocksLeftToAllocate of most urgent
//                    mostUrgentAssn.numBlocksLeftToAllocate -= 1
//                    
//                    // re-sort by urgency, restating mostUrgentAssn so it updates
//                    orderedAssignmentArray = orderedAssignmentArray.sort(isOrderedBefore)
//                    mostUrgentAssn = orderedAssignmentArray[0]
//                }
//                    
//                    // if needs to switch to tomorrow, don't decrement because it didn't allocate
//                else {
//                    day = temp.dayOut
//                }
//                
//                // either way, assign minute
//                minute = temp.minuteOut
//            }
//            return
//        }
//    }
    
//    func putBlockInCalArrayAtFirstFreeSpotToday(assg: Assignment, dayIn: Int,
//                                                minuteIn: Int) -> (dayOut: Int, minuteOut: Int) {
//        var dayOut = 0
//        var minuteOut = 0
//        
//        // if not enough time to allocate before working hours are up, switch to tomorrow
//        if minuteIn + WORKING_INTERVAL_SIZE > lastWorkingMinute {
//            minuteOut = firstWorkingMinute
//            dayOut = dayIn + 1
//            return (dayOut, minuteOut)
//        }
//        
//        var j = 0
//        
//        // iterate through the day to where the last working block starts
//        for i in minuteIn..<lastWorkingMinute - WORKING_INTERVAL_SIZE + 1 {
//            // if there's a block available from this moment on (this ever increasing moment starting at minuteIn)
//            if isBlockFree(i, dIn: dayIn)  {
//                // allocate to it (the next 15 cells)
//                j = i
//                while (j < i + WORKING_INTERVAL_SIZE) {
//                    // safeguard
//                    if let _ = calendarArray[j][dayIn] as? Assignment {
//                        // print error message to developer because cal array should have been wiped
//                        print("ERROR! Calendar array was not properly cleared, or this allocation did not start at the correct spot (one after the previous slot was allocated to)")
//                    }
//                    calendarArray[j][dayIn] = assg
//                    j += 1
//                }
//                
//                // update minuteOut
//                minuteOut = j
//                dayOut = dayIn
//                return (dayOut, minuteOut)
//            }
//        }
//        return (dayOut, minuteOut)
//    }
    
//    func isBlockFree(minIn: Int, dIn: Int) -> Bool {
//        // if 15 minutes in a row are free (1 block)
//        var count = 0
//        if minIn >= firstWorkingMinute {
//            for i in minIn..<(minIn + WORKING_INTERVAL_SIZE - 1) {
//                if calendarArray[minIn][dIn].title == "Unnamed Task" && isNextSameAsThis(i, col: dIn) {
//                    count += 1
//                }
//            }
//            
//            // is minus one because it only looks at whether the next one is the same.  Doesn't count for this one.
//            if count == WORKING_INTERVAL_SIZE - 1 {
//                return true
//            }
//                
//            else {
//                return false
//            }
//        }
//        
//        return false
//    }
    
    override init () {
        // also initializes member variables (tasks array)
        super.init()
        self.loadFromDisc()
        self.allocateTime()
    }
    
    // add save method
    func save() {
        
        let archive: NSData = NSKeyedArchiver.archivedDataWithRootObject(classArray)
        let archiveAppt: NSData = NSKeyedArchiver.archivedDataWithRootObject(appointmentArray)
        let archiveSettings: NSData = NSKeyedArchiver.archivedDataWithRootObject(settingsArray)
        let archiveSelectedDate: NSData = NSKeyedArchiver.archivedDataWithRootObject(selectedDate)
//        let archiveCal: NSData = NSKeyedArchiver.archivedDataWithRootObject
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archive, forKey: "classArray")
        defaults.setObject(archiveAppt, forKey: "appointmentArray")
        defaults.setObject(archiveSelectedDate, forKey: "selectedDate")
//        defaults.setObject(archiveCal, forKey: "calendarArray")
        
        setSettingsArray()
        assert(settingsArray.count == 2, "setSettingsArray func failed")
        defaults.setObject(archiveSettings, forKey: "settingsArray")
        
        
        defaults.synchronize()
        
        
    }
    
    func loadFromDisc() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let archive = defaults.objectForKey("classArray") as? NSData ?? NSData()
        
        let archiveAppt = defaults.objectForKey("appointmentArray") as? NSData ?? NSData()
        
        let archiveSettings = defaults.objectForKey("settingsArray") as? NSData ?? NSData()
        
        let archiveSelectedDate = defaults.objectForKey("selectedDate") as? NSData ?? NSData()
        
//        let archiveCal = defaults.objectForKey("calendarArray") as? NSData ?? NSData()
        
        classArray = NSKeyedUnarchiver.unarchiveObjectWithData(archive) as? [Class] ?? []
        
        appointmentArray = NSKeyedUnarchiver.unarchiveObjectWithData(archiveAppt) as? [Appointment] ?? []
        
        settingsArray = NSKeyedUnarchiver.unarchiveObjectWithData(archiveSettings) as? [NSDate] ?? []
        
//        if let calArray = NSKeyedUnarchiver.unarchiveObjectWithData(archiveCal) as? [[Task]] {
//            calendarArray = calArray
//        }
//        else {
//            calendarArray = Array(count: 28, repeatedValue: Array(count: 0, repeatedValue: Free()))
//        }
        
        // selectedDate
        if let temp = NSKeyedUnarchiver.unarchiveObjectWithData(archiveSelectedDate) as? NSDate {
            selectedDate = temp
        }
            
        else {
            selectedDate = NSDate()
            //assert(false, "save and load failed for selectedDate")
        }
    }
}