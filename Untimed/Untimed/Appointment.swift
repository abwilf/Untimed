//
//  Appointment.swift
//  Untimed
//
//  Created by Alex Wilf on 3/29/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class Appointment: Task {
    
//    // to test: var startTime = "11.30"
//    var startTime: NSDate = NSDate()
//    
//    // to test: var endTime = " 1 am tomorrow"
//    var endTime: NSDate = NSDate()
    
    var doesRepeat: Bool {
        if repeatOptionsIndex == 0 {
            return false
        }
        return true
    }
    
    var repetitions: [Appointment] = []
    
    // FIXME: get rid of this
    var repeatData = RepeatDataStruct()
    
    // repeatDaysIndex[0] corresponds to Sunday and [6] to Saturday
    var repeatDaysIndex = [Bool](count: 7, repeatedValue: false)
    
//    var daysToRepeat = RepeatDays()
    
    // 0: never
    // 1: daily
    // 2: every weekday
    // 3: weekly
    // 4: custom
    var repeatOptionsIndex = 0
    
    // FIXME: either make it a bool or make a third option for after so many repetitions
    // 0: never
    // 1: specific date
    var endRepeatIndex = 0
    
    var endRepeatDate: NSDate? = nil
    
    func allocateAppointmentRepetitions() {
        if !doesRepeat {
            return
        }
        else if repeatOptionsIndex == 1 {
            repeatDaily()
        }
        else if repeatOptionsIndex == 2 {
            repeatEveryWeekday()
        }
        else if repeatOptionsIndex == 3 {
            repeatWeekly()
        }
        else if repeatOptionsIndex == 4 {
            repeatCustom()
        }
    }
    
    func updateRepetitions() {
        if !doesRepeat {
            return
        }
        else if repeatOptionsIndex == 1 {
             updateRepeatDaily()
        }
        else if repeatOptionsIndex == 2 {
             updateRepeatEveryWeekday()
        }
        else if repeatOptionsIndex == 3 {
             updateRepeatWeekly()
        }
        else if repeatOptionsIndex == 4 {
             updateRepeatCustom()
        }
    }
    
    private func repeatDaily() {
        // FIXME: how to work without endRepeat Date
        for i in 1..<26 {
            let daysToAdd = i
            
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    private func updateRepeatDaily() {
        assert(!repetitions.isEmpty, "\n\n Can't update an empty repetitions array \n\n")
        while repetitions[0].startTime.calendarDayIndex() < 0 {
            repetitions.removeFirst()
            let lastRep = repetitions.last!
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: lastRep.startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: lastRep.endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    private func repeatEveryWeekday() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        for i in 1..<19 {
            let daysToAdd = i
            
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: daysToAdd, toDate: startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: daysToAdd, toDate: endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    private func updateRepeatEveryWeekday() {
        assert(!repetitions.isEmpty, "\n\n Can't update an empty repetitions array \n\n")
        while repetitions[0].startTime.calendarDayIndex() < 0 {
            repetitions.removeFirst()
            let lastRep = repetitions.last!
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: 1, toDate: lastRep.startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: 1, toDate: lastRep.endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    private func repeatWeekly() {
        for i in 1..<28 {
            let daysToAdd = i * 7
            
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    private func updateRepeatWeekly() {
        assert(!repetitions.isEmpty, "\n\n Can't update an empty repetitions array \n\n")
        while repetitions[0].startTime.calendarDayIndex() < 0 {
            repetitions.removeFirst()
            let lastRep = repetitions.last!
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: 7, toDate: lastRep.startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: 7, toDate: lastRep.endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    // note: this isn't very efficient
    private func repeatCustom() {        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        for i in 1..<28 {
            let daysToAdd = i
            
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            let dayOfWeek = dateFormatter.stringFromDate(calculatedStartDate!)
            if repeatDaysIndex[dayStringToIndex[dayOfWeek]!] {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                
                repetitions.append(appointmentToAdd)
            }
        }
    }
    
    private func updateRepeatCustom() {
        assert(!repetitions.isEmpty, "\n\n Can't update an empty repetitions array \n\n")
        while repetitions[0].startTime.calendarDayIndex() < 0 {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE"
            
            repetitions.removeFirst()
            let lastRep = repetitions.last!
            
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: 1, toDate: lastRep.startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Weekday, value: 1, toDate: lastRep.endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let dayOfWeek = dateFormatter.stringFromDate(calculatedStartDate!)
                if repeatDaysIndex[dayStringToIndex[dayOfWeek]!] {
                    let appointmentToAdd = Appointment()
                    appointmentToAdd.title = self.title
                    appointmentToAdd.startTime = calculatedStartDate!
                    appointmentToAdd.endTime = calculatedEndDate!
                    
                    repetitions.append(appointmentToAdd)
                }
            }
            else {
                return
            }
        }
    }
    
    enum repeatOptions: Int {
        case Never = 0
        case Daily
        case EveryWeekday
        case Weekly
        case Custom
    }
    
//    struct RepeatDays {
//        var Sunday = false
//        var Monday = false
//        var Tuesday = false
//        var Wednesday = false
//        var Thursday = false
//        var Friday = false
//        var Saturday = false
//    }
    

    
    var dayIndexToString: [Int: String] = [0: "Sunday", 1: "Monday", 2: "Tuesday",
                                      3: "Wednesday", 4: "Thursday", 5: "Friday",
                                      6: "Saturday"]
    
    var dayStringToIndex: [String: Int] = ["Sunday": 0, "Monday": 1, "Tuesday": 2,
                                           "Wednesday": 3, "Thursday": 4, "Friday": 5,
                                           "Saturday": 6]
    
    struct RepeatDataStruct {
        var daysOfWeek: Int? = nil
       // var repeatOption: repeatOptions = repeatOptions(rawValue: repeatOptionsIndex)
        var endRepeatDate: NSDate? = nil
    }
    
    let repeatOptionsArray: [String] = ["Never", "Daily", "Every Weekday", "Weekly", "Custom"] 
    
    private func repeatApptSwitch() {
        if let repeatOption = repeatOptions(rawValue: repeatOptionsIndex) {
            switch repeatOption {
            case .Never: break
            case .Daily: repeatAppt(.Daily)
            case .EveryWeekday: repeatAppt(.EveryWeekday)
            case .Weekly: repeatAppt(.Weekly)
            case .Custom: break
            }
        }
    }
    
    private func repeatAppt(option: repeatOptions) {
        if option == .Daily {
            for i in 0..<7 {
                repeatDaysIndex[i] = true
            }
//            daysToRepeat.Sunday = true; daysToRepeat.Monday = true
//            daysToRepeat.Tuesday = true; daysToRepeat.Wednesday = true
//            daysToRepeat.Thursday = true; daysToRepeat.Friday = true
//            daysToRepeat.Saturday = true
        }
        if option == .EveryWeekday {
            for i in 1..<6 {
                repeatDaysIndex[i] = true
            }
            repeatDaysIndex[0] = false
            repeatDaysIndex[6] = false
//            daysToRepeat.Monday = true; daysToRepeat.Tuesday = true
//            daysToRepeat.Wednesday = true; daysToRepeat.Thursday = true
//            daysToRepeat.Friday = true
        }
        if option == .Weekly {
//            let day = dayToString[0]
//            repeatDays.dayToString[0]  = true
        }
    }
    
    func extractDayofWeekFromStartTime(date: NSDate) -> String {
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Minute, .Month, .Year]
        
        let dateComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: startTime)
        
        return dayIndexToString[dateComponents.day]!
    }
    
//    var dsCalAdjustedStartLocation: Int? = nil
//    var dsCalAdjustedEndLocation: Int? = nil
    
    func adjustEndTime() -> Int {
        let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
        
        let adjustedEndTimeComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: endTime)
        
        if adjustedEndTimeComponents.minute > 0 {
            return adjustedEndTimeComponents.hour + 1
        }
        return adjustedEndTimeComponents.hour
    }
    
    override init() {
        super.init()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(startTime, forKey:"StartTime")
        aCoder.encodeObject(endTime, forKey:"EndTime")
        aCoder.encodeObject(title, forKey:"Title")
        aCoder.encodeInteger(repeatOptionsIndex, forKey:"Repeat Options Index")
        
        aCoder.encodeObject(repeatDaysIndex, forKey: "Repeat Days Index")
        
        
        aCoder.encodeObject(endRepeatDate, forKey: "End RepeatDate")
        
        aCoder.encodeObject(repetitions, forKey: "repetitions")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startTime = aDecoder.decodeObjectForKey("StartTime") as! NSDate
        self.endTime = aDecoder.decodeObjectForKey("EndTime") as! NSDate
        self.repeatOptionsIndex = aDecoder.decodeIntegerForKey("Repeat Options Index")
        
        // FIXME: this isn't loading correctly
        self.repeatDaysIndex = aDecoder.decodeObjectForKey("Repeat Days Index") as! [Bool]
        
        
        self.endRepeatDate = aDecoder.decodeObjectForKey("End Repeat Date") as? NSDate
        aDecoder.decodeObjectForKey("Title") as? String
        
        self.repetitions = aDecoder.decodeObjectForKey("repetitions") as? [Appointment] ?? []
    }
    
}