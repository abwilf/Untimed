//
//  Appointment.swift
//  Untimed
//
//  Created by Alex Wilf on 3/29/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import Foundation

class Appointment: Task {
    
    // to test: var startTime = "11.30"
    var startTime: NSDate = NSDate()
    
    // to test: var endTime = " 1 am tomorrow"
    var endTime: NSDate = NSDate()
    
    var doesRepeat: Bool = false
    
    var repeatData = RepeatDataStruct()
    
//    var daysToRepeat = RepeatDays()
    
    // 0: never
    // 1: daily
    // 2: every weekday
    // 3: weekly
    // 4: custom
    var repeatOptionsIndex = 0
    
    func setRepeatOptionsIndex(index index: Int) {
        if index < repeatOptionsArray.count {
            repeatOptionsIndex = index
        }
        else {
            assert(false)
        }
    }
    
    // 0: never
    // 1: specific date
    var endRepeatIndex = 0
    
    enum repeatOptions: Int {
        case Never = 0
        case Daily
        case EveryWeekday
        case Weekly
        case Custom
    }
    
    let repeatOptionsArray: [String] = ["Never", "Daily", "Every Weekday", "Weekly", "Custom"]
    
//    struct RepeatDays {
//        var Sunday = false
//        var Monday = false
//        var Tuesday = false
//        var Wednesday = false
//        var Thursday = false
//        var Friday = false
//        var Saturday = false
//    }
    
    // repeatDaysIndex[0] corresponds to Sunday and [6] to Saturday
    var repeatDaysIndex = [Bool](count: 7, repeatedValue: false)
    
    var dayIndexToString: [Int: String] = [0: "Sunday", 1: "Monday", 2: "Tuesday",
                                      3: "Wednesday", 4: "Thursday", 5: "Friday",
                                      6: "Saturday"]
    
    struct RepeatDataStruct {
        var daysOfWeek: Int? = nil
       // var repeatOption: repeatOptions = repeatOptions(rawValue: repeatOptionsIndex)
        var endRepeatDate: NSDate? = nil
    }
    
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
        doesRepeat = true
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
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startTime = aDecoder.decodeObjectForKey("StartTime") as! NSDate
        self.endTime = aDecoder.decodeObjectForKey("EndTime") as! NSDate
        self.endTime = aDecoder.decodeObjectForKey("EndTime") as! NSDate
        aDecoder.decodeObjectForKey("Title") as? String
        
    }
    
}