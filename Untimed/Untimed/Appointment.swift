//
//  Appointment.swift
//  Untimed
//
//  Created by Alex Wilf on 3/29/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class Appointment: Task {
    
    var doesRepeat: Bool {
        get {
            if repeatOptionsIndex == 0 {
                return false
            }
            return true
        }
    }
    
    var isRepetition: Bool = false
    
    var superAppt: Appointment? = nil
    
    var repetitions: [Appointment] = []
    
    var repeatData = RepeatDataStruct()
    
    // repeatDaysIndex[0] corresponds to Sunday and [6] to Saturday
    var repeatDaysIndex = [Bool](count: 7, repeatedValue: false)
    
    
    // 0: never
    // 1: daily
    // 2: every weekday
    // 3: weekly
    // 4: custom
    var repeatOptionsIndex = 0
    
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
        repetitions.append(self)
        for i in 1..<26 {
            let daysToAdd = i
            
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                appointmentToAdd.isRepetition = true
                appointmentToAdd.superAppt = self
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
                appointmentToAdd.isRepetition = true
                appointmentToAdd.superAppt = self
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    private func repeatEveryWeekday() {
        repetitions.append(self)

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
                appointmentToAdd.isRepetition = true
                appointmentToAdd.superAppt = self
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
                appointmentToAdd.isRepetition = true
                appointmentToAdd.superAppt = self
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    private func repeatWeekly() {
        repetitions.append(self)

        for i in 1..<28 {
            let daysToAdd = i * 7
            
            let calculatedStartDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: startTime, options: NSCalendarOptions.init(rawValue: 0))
            let calculatedEndDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: daysToAdd, toDate: endTime, options: NSCalendarOptions.init(rawValue: 0))
            
            if calculatedStartDate?.calendarDayIndex() < 28 {
                let appointmentToAdd = Appointment()
                appointmentToAdd.title = self.title
                appointmentToAdd.startTime = calculatedStartDate!
                appointmentToAdd.endTime = calculatedEndDate!
                appointmentToAdd.isRepetition = true
                appointmentToAdd.superAppt = self
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
                appointmentToAdd.isRepetition = true
                appointmentToAdd.superAppt = self
                repetitions.append(appointmentToAdd)
            }
            else {
                return
            }
        }
    }
    
    // note: this isn't very efficient
    private func repeatCustom() {
        repetitions.append(self)

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
                appointmentToAdd.isRepetition = true
                appointmentToAdd.superAppt = self
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
                    appointmentToAdd.isRepetition = true
                    appointmentToAdd.superAppt = self
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
    var dayIndexToString: [Int: String] = [0: "Sunday", 1: "Monday", 2: "Tuesday",
                                      3: "Wednesday", 4: "Thursday", 5: "Friday",
                                      6: "Saturday"]
    
    var dayStringToIndex: [String: Int] = ["Sunday": 0, "Monday": 1, "Tuesday": 2,
                                           "Wednesday": 3, "Thursday": 4, "Friday": 5,
                                           "Saturday": 6]
    
    struct RepeatDataStruct {
        var daysOfWeek: Int? = nil
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
        }
        if option == .EveryWeekday {
            for i in 1..<6 {
                repeatDaysIndex[i] = true
            }
            repeatDaysIndex[0] = false
            repeatDaysIndex[6] = false
        }
        if option == .Weekly {
            // do nothing
        }
    }
    
    func extractDayofWeekFromStartTime(date: NSDate) -> String {
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Minute, .Month, .Year]
        
        let dateComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: startTime)
        
        return dayIndexToString[dateComponents.day]!
    }
    
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
        aCoder.encodeBool(isRepetition, forKey: "isRepetition")
        aCoder.encodeObject(superAppt, forKey: "superAppt")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startTime = aDecoder.decodeObjectForKey("StartTime") as! NSDate
        self.endTime = aDecoder.decodeObjectForKey("EndTime") as! NSDate
        self.repeatOptionsIndex = aDecoder.decodeIntegerForKey("Repeat Options Index")
        self.isRepetition = aDecoder.decodeBoolForKey("isRepetition")
        self.repeatDaysIndex = aDecoder.decodeObjectForKey("Repeat Days Index") as! [Bool]
        self.superAppt = aDecoder.decodeObjectForKey("superAppt") as? Appointment
        
        self.endRepeatDate = aDecoder.decodeObjectForKey("End Repeat Date") as? NSDate
        aDecoder.decodeObjectForKey("Title") as? String
        
        self.repetitions = aDecoder.decodeObjectForKey("repetitions") as? [Appointment] ?? []
    }
    
}