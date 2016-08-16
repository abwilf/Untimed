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

class TaskManager: NSObject {

    var classArray: [Class] = []
    var appointmentArray: [Appointment] = []
    var focusTasksArr: [Task] = []
    var selectedDate: NSDate = NSDate()
    
    var captureListText: String = ""
    
    // 28 rows (days) x 0 objects to start, objects will be appended to each column as needed
    var calendarArray: [[Task]] = Array(count: 28,
                                        repeatedValue: Array(count: 0, repeatedValue: Free()))
    
    var calendarArrayHasChanged = false
    
    var dateLastUsed = NSDate()
    
    var settingsArray: [NSDate] = []
    
    func setSettingsArray() {
        // clear
        settingsArray = []
        
        // refill
        settingsArray += [firstWorkingHour]
        
        settingsArray += [lastWorkingHour]
}
    
    var firstWorkingHour = NSDate(dateString: "08:00")
    var lastWorkingHour = NSDate(dateString: "23:00")
    
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
    
    func calArrayDescriptionAtIndex(min: Int, day: Int) {
        print ("\(calendarArray[min][day].title)")
    }
    
    // create variables to order array later
    var unfilteredArray: [Task] = Array(count: 40, repeatedValue: Free())
    var assignmentArray = [Assignment]()
    var orderedAssignmentArray = [Assignment]()
    
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
    
    func clearCalArray() {
        calendarArray = Array(count: 28, repeatedValue: Array(count: 0, repeatedValue: Free()))
    }
    
    // for testing
    private func clearClassArray() {
        for _ in classArray {
            classArray.removeLast()
        }
        save()
    }
    
    // for testing
    private func clearAppointmentArray() {
        for _ in appointmentArray {
            appointmentArray.removeLast()
        }
    }

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
        
        // updateCalArr()
        
        // put appts in
        allocateAppts()
        
//         updateCalArray()
        
//        allocateWorkingBlocks()
        
        //allocateAssignments()
    }
    
    func updateCalArray() {
        if calendarArrayHasChanged {
            clearCalArray()
            allocateAppts()
        }
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
//                            assert(false, "/n/n past repetitions should have been removed already /n/n")
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
    
    override init () {
        // also initializes member variables (tasks array)
        super.init()
        self.loadFromDisc()
        self.allocateTime()
    }
    
    // add save method
    func save() {
        
        let archiveClass: NSData = NSKeyedArchiver.archivedDataWithRootObject(classArray)
        let archiveAppt: NSData = NSKeyedArchiver.archivedDataWithRootObject(appointmentArray)
        let archiveSettings: NSData = NSKeyedArchiver.archivedDataWithRootObject(settingsArray)
        let archiveSelectedDate: NSData = NSKeyedArchiver.archivedDataWithRootObject(selectedDate)
        let archiveCaptureListText: NSData = NSKeyedArchiver.archivedDataWithRootObject(captureListText)
//        let archiveCal: NSData = NSKeyedArchiver.archivedDataWithRootObject(calendarArray)
        let archiveDateLastUsed: NSData = NSKeyedArchiver.archivedDataWithRootObject(dateLastUsed)

//        let archiveCal: NSData = NSKeyedArchiver.archivedDataWithRootObject
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archiveClass, forKey: "classArray")
        defaults.setObject(archiveAppt, forKey: "appointmentArray")
        defaults.setObject(archiveSelectedDate, forKey: "selectedDate")
        defaults.setObject(archiveCaptureListText, forKey: "captureListText")
//        defaults.setObject(archiveCal, forKey: "calendarArray")
        defaults.setObject(archiveDateLastUsed, forKey: "dateLastUsed")
        
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
        
//        let archiveSelectedDate = defaults.objectForKey("selectedDate") as? NSData ?? NSData()
        
        let archiveCaptureListText = defaults.objectForKey("captureListText") as? NSData ?? NSData()

//        let archiveCal = defaults.objectForKey("calendarArray") as? NSData ?? NSData()
        
        // unarchive all objects
        classArray = NSKeyedUnarchiver.unarchiveObjectWithData(archive) as? [Class] ?? []
        
        appointmentArray = NSKeyedUnarchiver.unarchiveObjectWithData(archiveAppt) as? [Appointment] ?? []
        
        settingsArray = NSKeyedUnarchiver.unarchiveObjectWithData(archiveSettings) as? [NSDate] ?? []
        
        // captureListText
        if let temp = NSKeyedUnarchiver.unarchiveObjectWithData(archiveCaptureListText) as? String {
            captureListText = temp
        }
            
        else {
            captureListText = ""
            // FIXME: this will fail for user's first run
//            assert(false, "save and load failed for selectedDate")
        }
        
        
//        if let calArray = NSKeyedUnarchiver.unarchiveObjectWithData(archiveCal) as? [[Task]] {
//            calendarArray = calArray
//        }
//        else {
//            calendarArray = Array(count: 28, repeatedValue: Array(count: 0, repeatedValue: Free()))
//        }
//        
//        dateLastUsed = NSKeyedUnarchiver.unarchiveObjectWithData(archiveCal) as? NSDate ?? NSDate()
        
        // selectedDate
//        if let temp = NSKeyedUnarchiver.unarchiveObjectWithData(archiveSelectedDate) as? NSDate {
//            selectedDate = temp
//        }
//            
//        else {
            selectedDate = NSDate()
        // FIXME: this is just for testing
//            assert(false, "save and load failed for selectedDate")
//        }
        
        
        
    }
}