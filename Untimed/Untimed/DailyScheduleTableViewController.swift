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
            
            // problem may be here?!
            taskManager.allocateTime()
            createDSCalArray()
            tableView.reloadData()
        }
    }
    
    
    // update selectedDate with changed date value
    @IBAction func unwindAndChangeDate(sender: UIStoryboardSegue) {
        if let cdvc = sender.sourceViewController as? ChangeDateViewController {
            selectedDate = cdvc.newDate
            taskManager.loadFromDisc()
            taskManager.allocateTime()
            createDSCalArray()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromSettings(sender: UIStoryboardSegue) {
        if let stvc = sender.sourceViewController as? SettingsTableViewController {
            taskManager.firstWorkingMinute = stvc.fwm
            taskManager.lastWorkingMinute = stvc.lwm
            taskManager.save()
            tableView.reloadData()
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
        
        //if indexPath.row <= dsCalArray.count {
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
        
        
//            if let temp = dsCalArray[indexPath.row][dateLocationDay] as? Assignment {
//                
//                
//                let didntDoAction = UIAlertAction(title: "Didn't do / don't want to", style: .Default) { (action) in
//                    
//                    // count numBlocks that should have been completed
//                    let numBlocks = self.countNumBlocksInInterval(temp.dsCalAdjustedStartLocation!,
//                                                                  end: temp.dsCalAdjustedEndLocation!)
//                    
//                    // add the value back to assignment in tasks array
//                    var index = 0
//                    
//                    for i in 0..<self.taskManager.tasks.count {
//                        if temp == self.taskManager.tasks[i] {
//                            index = i
//                        }
//                    }
//                    
//                    // clear tmCalArray at that spot
//
//                    /*
//                    if let temp = self.taskManager.tasks[index] as? Assignment {
//                        temp.numBlocksLeftToAllocate += numBlocks
//                    }
//                    */
//                    
//                    // reallocate time
//                    self.taskManager.allocateTime()
//                    
//                    // print (self.taskManager.calendarArray[1050][0])
//                    
//                    // copy to other array
//                    self.taskManager = self.taskManager.copy() as! TaskManager
//                    
//                    // recreate dsCalArray from updated tM
//                    self.createDSCalArray()
//                    
//                    // save
//                    self.taskManager.save()
//                    
//                    // test
//                    // print (self.dsCalArray[1])
//                    
//                    // FIXME: make sure to loadfromdisc in tasktabletable
//                    
//                    // reload data
//                    tableView.reloadData()
//                    
//                }
//                
//                let needTimeAction = UIAlertAction(title: "I need more time", style: .Default) { (action) in
//                    self.performSegueWithIdentifier("More Time Segue", sender: DailyScheduleTableViewController())
//                }
//                let somethingElseAction = UIAlertAction(title: "I'd rather do something else", style: .Default) { (action) in
//                    self.performSegueWithIdentifier("Choose Assignment Segue", sender: DailyScheduleTableViewController())
//                }
//                let finishedAction = UIAlertAction(title: "I've finished this assignment", style: .Default) { (action) in
//                }
//                let freeAction = UIAlertAction(title: "Free this block", style: .Default) { (action) in
//                }
//                
//                alertController.addAction(didntDoAction)
//                alertController.addAction(needTimeAction)
//                alertController.addAction(somethingElseAction)
//                alertController.addAction(freeAction)
//                alertController.addAction(finishedAction)
//            }
        
            if let _ = dsCalArray[indexPath.row][dateLocationDay] as? Appointment {
                let rescheduleAction = UIAlertAction(title: "Reschedule", style: .Default) { (action) in
                }
                
                alertController.addAction(rescheduleAction)
                alertController.addAction(deleteAction)
            }
            
            if let _ = dsCalArray[indexPath.row][dateLocationDay] as? Free {
                let addApptAction = UIAlertAction(title: "Add appointment", style: .Default) { (action) in
                }
                
                alertController.addAction(addApptAction)
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
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        taskManager.loadFromDisc()
        
        taskManager.allocateTime()
        
        createDSCalArray()
        
        // to deal with indexPath.row issues, cull tasks not within working period
        createPrintedDSCalArray()
        
        tableView.reloadData()
    }
    
    // connecting add and single task viewer pages to this
    @IBAction func unwindAndAddTask(sender: UIStoryboardSegue)
    {
        // add assignment created here!
        if let aavc = sender.sourceViewController as? AddAssignmentTableViewController {
            
            taskManager.addTask(aavc.addedAssignment)
            
            // tableView = inherited property from UITableViewCOntroller class
            tableView.reloadData()
        }
        
        
        // add appointment created here!
        if let aapptvc = sender.sourceViewController as? AddAppointmentTableViewController {
            taskManager.addTask(aapptvc.addedAppointment)
            
            tableView.reloadData()
        }
        
        // Pull any data from the view controller which initiated the unwind segue.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    // FIXME: change this when we have userinputted values
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dsCalArray.count
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
            if indexPath.row < printedDSCalArray.count {
                let task = printedDSCalArray[indexPath.row][dateLocationDay]
                cell.textLabel?.text = task?.title
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
            // alter object's title
            temp.title = minInHrCoord(temp.dsCalAdjustedStartLocation!) + " - " + minInHrCoord(temp.dsCalAdjustedEndLocation! + 1) + ": Free"
            addTaskToPrintedCal(printedCalRowIn, dayIn: dayCoorIn, taskIn: temp)
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

    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        //taskManager.tasksDescription()

        // create proprietary array
        createDSCalArray()
        
        // for testing
        dsCalArrayDescription()
        
        
        tableView.reloadData()
        title = "Today"
    }
 */
    
    
    
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
    }
}