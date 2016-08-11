
//
//  DailyScheduleTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/7/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class DailyScheduleTableViewController: UITableViewController{
    var taskManager = TaskManager()
    var dateLocationDay: Int = 0
    let MINS_IN_DAY = 1440
    let MINS_IN_HOUR = 60
    
    var dsCalArray: [[Task?]] = []
    var printedDSCalArray: [[Task?]] = []

    // create counting variables for allocation to tableview
    var startLocation = 0
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    func hourMinuteStringFromNSDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let string = dateFormatter.stringFromDate(date)
        return string
    }
    
    func minInHrCoord(minuteCoordinateIn: Int) -> String {
        var hour = 0
        var minute = 0
        
        // start at a.m.
        var whichTime = 0
        
        // calculate hour
        hour = minuteCoordinateIn / 60
        
        // decide if a.m. (0) or p.m. (1)
        if hour < 12 {
            whichTime = 0
        }
        
        else {
            whichTime = 1
        }
        
        // midnight of the following day is in a.m.
        if hour == 24 && minute == 0 {
            whichTime = 0
        }
        
        // convert from 24 hour time to 12 hour time
        if hour > 12 {
            hour -= 12
        }
        
        if hour == 0 {
            hour = 12
        }
        // calculate minute
        minute = minuteCoordinateIn % 60
        
        // fix the 10:00 problem
        if minute < 10 {
            if whichTime == 0 {
                return "\(hour):0\(minute) am"
            }
                
            else {
                return "\(hour):0\(minute) pm"
            }
        }
        
        else {
            if whichTime == 0 {
                return "\(hour):\(minute) am"
            }
                
            else {
                return "\(hour):\(minute) pm"
            }
        }
    }
    
    var selectedDate = NSDate() {
        didSet {
            updateTitle()
            
            // re-allocate
            taskManager.loadFromDisc()
            
            taskManager.allocateTime()
            tableView.reloadData()
        }
    }
    
    // save from add appointment
    @IBAction func unwindAndAddAppt(sender: UIStoryboardSegue) {
        if let aapptvc = sender.sourceViewController as? AddAppointmentTableViewController {
            taskManager.addAppointment(aapptvc.addedAppointment)
            taskManager.allocateAppts()
            taskManager.save()
            tableView.reloadData()
        }
    }
    
    // update selectedDate with changed date value
    @IBAction func unwindAndChangeDate(sender: UIStoryboardSegue) {
        if let cdvc = sender.sourceViewController as? ChangeDateViewController {
            selectedDate = cdvc.newDate
            taskManager.loadFromDisc()
            taskManager.allocateTime()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromPickFocus(sender: UIStoryboardSegue) {
        
        if let paatvc = sender.sourceViewController as? ProjectsAndAssignmentsTableViewController {
            print (paatvc.tmObj.calendarArray[0][0])
            taskManager = paatvc.tmObj
            taskManager.save()
            tableView.reloadData()
        }
        
        if let pttvc = sender.sourceViewController as? ProjTasksTableViewController {
            pttvc.updateFocusTasks()
            taskManager = pttvc.tmObj
            taskManager.save()
            tableView.reloadData()
        }
        
        if let pttvc = sender.sourceViewController as? TaskTableTableViewController {
            taskManager = pttvc.tmObj
            taskManager.save()
            tableView.reloadData()
        }
    }
    
    
    @IBAction func unwindFromAccountability (sender: UIStoryboardSegue) {
        if let atvc = sender.sourceViewController as? AccountabilityTableViewController {
            // maybe get rid of tasks
        }
    }

    
    func updateTitle() {
        dateLocationDay = nsDateInCalFormat(selectedDate).dayCoordinate
        if dateLocationDay == 0 {
            title = "Today"
        }
        
        if dateLocationDay == 1 {
            title = "Tomorrow"
        }
        
        if dateLocationDay > 1 {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let printedDate = dateFormatter.stringFromDate(selectedDate)
            title = "\(printedDate)"
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
    
    // supporting function
    func countNumBlocksInInterval(start: Int, end: Int) -> Int {
        let temp = ((end - start) / 15) + 1
        return temp
    }
    
    // action sheets
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let warningController = UIAlertController(title: "Are you sure you want to delete this appointment?", message: nil, preferredStyle: .Alert)
        
        // cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
    
        alertController.addAction(cancelAction)
        warningController.addAction(cancelAction)
        
        // delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            // delete warning
            self.presentViewController(warningController, animated: true) {
            }
        }
        warningController.addAction(deleteAction)
    
        if let _ = taskManager.calendarArray[indexPath.row][dateLocationDay] as? Appointment {
            let rescheduleAction = UIAlertAction(title: "Reschedule", style: .Default) { (action) in
            }
            
            alertController.addAction(rescheduleAction)
            alertController.addAction(deleteAction)
        }
        
        if let _ = taskManager.calendarArray[indexPath.row][dateLocationDay] as? Free {
            let addApptAction = UIAlertAction(title: "Add appointment", style: .Default) { (action) in
            }
            
            alertController.addAction(addApptAction)
        }
   
        if let _ = taskManager.calendarArray[indexPath.row][dateLocationDay] as? WorkingBlock {
            let selectFocusAction = UIAlertAction(title: "Select Focus", style: .Default) { (action) in self.performSegueWithIdentifier("Select Focus Segue", sender: self)
            }
            
            alertController.addAction(selectFocusAction)
        }
    
        self.presentViewController(alertController, animated: true, completion: nil)
    
        
        
    }
    
    @IBAction func reloadPressed(sender: UIBarButtonItem) {
        // re-allocate
        taskManager.loadFromDisc()
        taskManager.allocateTime()
        createDSCalArray()
        tableView.reloadData()
    }
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        // FIXME: doesn't account for case in which user doesn't check dscal before the day is over and after lastWorkingHour
        // FIXME: only do this if tm.focusTaskAr != empty 
        let now = NSDate()
        let nowValForComparison = now.getTimeValForComparison()
        let lastWorkingValForComparison = taskManager.lastWorkingHour.getTimeValForComparison()
        if nowValForComparison > lastWorkingValForComparison {
            self.performSegueWithIdentifier("Accountability Segue", sender: self)
        }
        
        taskManager.loadFromDisc()
    
        // set working minutes from saved settings array
        setWorkingMinutes()
        
        taskManager.allocateWorkingBlocksAtIndex(dayIndex: dateLocationDay)

        // for hambuger icon
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tableView.reloadData()
    }
    
    func setWorkingMinutes() {
        if taskManager.settingsArray.count == 2 {
            taskManager.firstWorkingMinute = taskManager.settingsArray[0]
            taskManager.lastWorkingMinute = taskManager.settingsArray[1]
        }
        
        else {
            taskManager.firstWorkingMinute = 480
            taskManager.lastWorkingMinute = 1140
        }
    }
    override func viewWillDisappear(animated: Bool) {
        //taskManager.clearWorkingBlocksAtIndex(dayIndex: dateLocationDay)
    }
    
//    // connecting add and single task viewer pages to this
//    @IBAction func unwindAndAddTask(sender: UIStoryboardSegue)
//    {
//        // add assignment created here!
//        if let aavc = sender.sourceViewController as? AddAssignmentTableViewController {
//            
//            taskManager.addAssignment(aavc.addedAssignment, forClass: )
//            
//            // tableView = inherited property from UITableViewCOntroller class
//            tableView.reloadData()
//        }
//        
//        
//        // add appointment created here!
//        if let aapptvc = sender.sourceViewController as? AddAppointmentTableViewController {
//            taskManager.addTask(aapptvc.addedAppointment)
//            
//            tableView.reloadData()
//        }
//        
//        // Pull any data from the view controller which initiated the unwind segue.
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    // FIXME: change this when we have userinputted values
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dsCalArray.count
        return taskManager.calendarArray[dateLocationDay].count
    }
    
    func isNextSameAsThis(row: Int, col: Int) -> Bool {
        if row > 0 && row < MINS_IN_DAY - 1 || row == 0 {
            if taskManager.calendarArray[row][col] == taskManager.calendarArray[row + 1][col] {
               return true
            }
            if let _ = taskManager.calendarArray[row][col] as? Free {
                if let _ = taskManager.calendarArray[row + 1][col] as? Free {
                return true
                }
            }
            if let _ = taskManager.calendarArray[row][col] as? WorkingBlock {
                if let _ = taskManager.calendarArray[row + 1][col] as? WorkingBlock {
                    return true
                }
            }
        }
        return false
    }
    
    func thereExistsAnApptOutsideWorkingDay() -> Bool {
        
        return false
    }
    
    func createPrintedDSCalArray() {
        // if task starts and ends within the working interval, add it
        for j in 0..<28 {
            var otherDayPCARowIndex = 0
            for i in 0..<self.dsCalArray.count {
                let task = dsCalArray[i][j]
                if (task?.dsCalAdjustedStartLocation >= taskManager.firstWorkingMinute) && (task?.dsCalAdjustedEndLocation <= taskManager.lastWorkingMinute) {
                    addToPrintedCalArray(otherDayPCARowIndex, dayCoorIn: j, taskIn: task)
                    otherDayPCARowIndex += 1
                }
            }
        }
    }
            // allocate elements from calendar array to cells in view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // giving cell information and telling where to find it
        let cell = tableView.dequeueReusableCellWithIdentifier("Daily Schedule Cell", forIndexPath: indexPath)
        
        if thereExistsAnApptOutsideWorkingDay() {
            // FIXME: ADD if it's before the working day
            
            // if it's after the working day
        }
            
        else {
            if indexPath.row < taskManager.calendarArray[taskManager.nsDateInCalFormat(selectedDate).dayCoordinate].count {
                let task = taskManager.calendarArray[dateLocationDay][indexPath.row]
            
                var label = ""
                var subLabel = ""
                
                if let temp = task as? Free {
                    
                    label = "\(hourMinuteStringFromNSDate(temp.startTime)) - \(hourMinuteStringFromNSDate(temp.endTime)): Free"
                }
                
                if let temp = task as? Appointment {
                    let title = temp.title
                    label = "\(hourMinuteStringFromNSDate(temp.startTime)) - \(hourMinuteStringFromNSDate(temp.endTime)): \(title)"
                }
                
                if let temp = task as? WorkingBlock {
                    label = "\(hourMinuteStringFromNSDate(temp.startTime)) - \(hourMinuteStringFromNSDate(temp.endTime)): Working Block"
                    for i in 0..<temp.focusArr.count {
                        subLabel = "Focus: "
                        
                        // if only one focus
                        if temp.focusArr.count == 1 {
                            subLabel += (temp.focusArr[i].title)
                        }
                        
                        // if more than one, but not the last one
                        else if i < temp.focusArr.count - 1 {
                            subLabel += (temp.focusArr[i].title) + ", "
                        }
                        
                        // the last one in the chain
                        else {
                            subLabel += (temp.focusArr[i].title)
                        }
                    }
                }
                
                cell.textLabel?.text = label
                cell.detailTextLabel?.text = subLabel

                return cell
            }
            else {
                cell.textLabel?.text = ""
                return cell
            }
        }
        
        return cell
    }
    
    
    /*
    func dsCalArrayDescription() {
        for var i = 0; i < dsCalArray.count; ++i {
            print ("\(dsCalArray[i].title)\n")
        }
    }
    */
    
    func createDSCalArray() {
        
        // create counting variables
        var cellDiff = 0

        // wipe dsCalArray
        dsCalArray = [[Task?]]()
        
        // iterate through taskManager's calArray
        for k in 0..<28 {
            // create count of what row you're at in the other day
            var otherDayIndex = 0
            
            var i = 0
            while i < MINS_IN_DAY {
                // wipe for reuse in each cell
                cellDiff = 0
                
                // starting location
                let j = i
                
                // Only deal with one block of same things.  If this element is the same as the one after it, increment counters.
                while isNextSameAsThis(i + cellDiff, col: k) {
                    cellDiff += 1
                }
                
                i += cellDiff
                
                // update object in tM calArray
                taskManager.calendarArray[i][k].dsCalAdjustedStartLocation = j
                taskManager.calendarArray[i][k].dsCalAdjustedEndLocation = i
                
                addTaskToDSCal(k, taskIn: taskManager.calendarArray[i][k], oDIndexIn: otherDayIndex)

                if k > 0 {
                    otherDayIndex += 1
                }
                
                i = i + 1
            }
        }
    }
    
    func addToPrintedCalArray(printedCalRowIn: Int, dayCoorIn: Int, taskIn: Task?) {
        
        if let temp = taskIn as? Free {
            
            temp.title = "\(taskManager.nsDateInCalFormat(temp.startTime).hourValue): \(taskManager.nsDateInCalFormat(temp.startTime).minuteValue) - \(taskManager.nsDateInCalFormat(temp.endTime).hourValue): \(taskManager.nsDateInCalFormat(temp.endTime).minuteValue)"
            
//            temp.title = minInHrCoord(temp.dsCalAdjustedStartLocation!) + " - " + minInHrCoord(temp.dsCalAdjustedEndLocation! + 1) + ": Free"
//            addTaskToPrintedCal(printedCalRowIn, dayIn: dayCoorIn, taskIn: temp)
        }
        
        if let temp = taskIn as? Appointment {
            let titleTemp = temp.title
            temp.title = minInHrCoord(temp.dsCalAdjustedStartLocation!) + " - " + minInHrCoord(temp.dsCalAdjustedEndLocation! + 1) + ": " + titleTemp
            addTaskToPrintedCal(printedCalRowIn, dayIn: dayCoorIn, taskIn: temp)
        }
        
        if let temp = taskIn as? WorkingBlock {
            temp.title = minInHrCoord(temp.dsCalAdjustedStartLocation!) + " - " + minInHrCoord(temp.dsCalAdjustedEndLocation! + 1) + ": Working Block"
            addTaskToPrintedCal(printedCalRowIn, dayIn: dayCoorIn, taskIn: temp)
        }
        
        
        //        if let temp = taskManager.calendarArray[endCoor][dayCoor] as? Assignment {
        
        //            temp.addAssignmentBlock(startCoor, adjustedEndTime: endCoor, dayCoord: dayCoor)
        //
        //            addTaskToDSCal(dayCoor, taskIn: temp.assignmentBlocks[0], oDIndexIn: oDRowIndex)
        //
        //            temp.removeFirstBlock()
        //        }
        
    }
    
    func copyAtRow(arr: [[Task?]], row: Int) -> [Task?] {
        var newRow = [Task?]()
        newRow = createRowWith28Nils()
        for k in 0..<28 {
            if let temp = arr[row][k] {
                newRow[k] = temp
            }
            else {
                // is optional.  ignore!
            }
        }
        return newRow
    }
    
    func createRowWith28Nils() -> [Task?]{
        // clear
        var row = [Task?]()
        for _ in 0..<28 {
            // add nils
            row += [nil]
        }
        
        return row
    }
    
    func addTaskToDSCal(dayIn: Int, taskIn: Task, oDIndexIn: Int) {
        // create row to append
        var newRow: [Task?] = createRowWith28Nils()
        
        if dayIn == 0 {
            // add to newRow and add that to dsCalArray
            newRow[0] = taskIn
            dsCalArray.append(newRow)
        }
            
        // if another day
        else {
            // if the amount of rows we're allocating to is less than the amount we've already created
            if oDIndexIn < dsCalArray.count {
                // copy dsCalArray at that row
                newRow = copyAtRow(dsCalArray, row: oDIndexIn)
                
                // add element to newRow
                newRow[dayIn] = taskIn
                
                // replace dsCalArray at that row with newRow
                for k in 0..<28 {
                    dsCalArray[oDIndexIn][k] = newRow[k]
                }
            }
                
            else {
                // add element to new row and append to dsCalArray
                newRow[dayIn] = taskIn
                dsCalArray.append(newRow)
            }
        }
    }
    
    
    func addTaskToPrintedCal(oDRowIndexIn: Int, dayIn: Int, taskIn: Task) {
        // create row to append
        var newRow: [Task?] = createRowWith28Nils()
        
        if dayIn == 0 {
            // add to newRow and add that to dsCalArray
            newRow[0] = taskIn
            printedDSCalArray.append(newRow)
        }
            
            // if another day
        else {
            // if the amount of rows we're allocating to is less than the amount we've already created
            if oDRowIndexIn < printedDSCalArray.count {
                // copy dsCalArray at that row
                newRow = copyAtRow(printedDSCalArray, row: oDRowIndexIn)
                
                // add element to newRow
                newRow[dayIn] = taskIn
                
                // replace printedCalArray at that row with newRow
                for k in 0..<28 {
                    printedDSCalArray[oDRowIndexIn][k] = newRow[k]
                }
            }
                
            else {
                // add element to new row and append to dsCalArray
                newRow[dayIn] = taskIn
                printedDSCalArray.append(newRow)
            }
        }
}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.settingsButton.title = NSString(string: "\u{2699}") as String
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            self.settingsButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }*/
 
    }
 
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    if (editingStyle == UITableViewCellEditingStyle.Delete){
    
    // delete and save
    taskManager.deleteTaskAtIndex(indexPath.row)
    tableView.reloadData()
    }
    }
    
    }
    */
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if (segue.identifier == "Change Date") {
            segue.destinationViewController.title = "Change Date"
        }
        
        if (segue.identifier == "DS To Settings") {
            // dealing with Nav controller in between views
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! SettingsTableViewController
            
            // pass in minute properties.
            targetController.fwm = taskManager.firstWorkingMinute
            targetController.lwm = taskManager.lastWorkingMinute
        }
        
        if (segue.identifier == "Select Focus Segue") {
            // dealing with Nav controller in between views
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! TaskTableTableViewController
            
            // pass in tmObj
            targetController.tmObj = taskManager
            
            if let indexSelected = tableView.indexPathForSelectedRow?.row {
                targetController.wbIndex = indexSelected
                targetController.dateLocationDay = dateLocationDay
                targetController.focusIndicator = true
                
             
            }
        }
        
        if (segue.identifier == "Accountability Segue") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! AccountabilityTableViewController
            
            targetController.focusTasks = taskManager.focusTasksArr
        }
    }
}