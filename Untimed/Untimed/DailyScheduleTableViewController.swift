//
//  DailyScheduleTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/7/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class DailyScheduleTableViewController: UITableViewController{
    
    let taskManager = TaskManager()
    var tmCopy = TaskManager()
    
    var dateLocationDay: Int = 0
    let MINS_IN_DAY = 1440
    let MINS_IN_HOUR = 60
    
    var dsCalArray: [[Task?]] = []

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
        
        if indexPath.row <= dsCalArray.count {
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
            
            if let temp = dsCalArray[indexPath.row] as? Assignment {
                let didntDoAction = UIAlertAction(title: "I didn't do this", style: .Default) { (action) in
                    // count numBlocks that should have been completed
                    let numBlocks = self.countNumBlocksInInterval(temp.dsCalAdjustedStartLocation, end: temp.dsCalAdjustedEndLocation)
                    
                    // add the value back to assignment in tasks array
                    var index = 0
                    
                    for var i = 0; i < self.taskManager.tasks.count; ++i {
                        if temp == self.taskManager.tasks[i] {
                            index = i
                        }
                    }
                    
                    if let temp = self.taskManager.tasks[index] as? Assignment {
                        temp.numBlocksLeftToAllocate += numBlocks
                    }
                    // reallocate time
                    self.taskManager.allocateTime()
                    
                    // copy to other array
                    self.tmCopy = self.taskManager.copy() as! TaskManager
                    
                    // recreate dsCalArray from updated tM
                    self.createDSCalArray()
                    
                    // save
                    self.taskManager.save()
                    
                    // FIXME: make sure to loadfromdisc in tasktabletable
                    
                    // reload data
                    tableView.reloadData()
                    
                }
                
                let needTimeAction = UIAlertAction(title: "I need more time", style: .Default) { (action) in
                    self.performSegueWithIdentifier("More Time Segue", sender: DailyScheduleTableViewController())
                }
                let somethingElseAction = UIAlertAction(title: "I'd rather do something else", style: .Default) { (action) in
                    self.performSegueWithIdentifier("Choose Assignment Segue", sender: DailyScheduleTableViewController())
                }
                let finishedAction = UIAlertAction(title: "I've finished this assignment", style: .Default) { (action) in
                }
                let freeAction = UIAlertAction(title: "Free this block", style: .Default) { (action) in
                }
                
                alertController.addAction(didntDoAction)
                alertController.addAction(needTimeAction)
                alertController.addAction(somethingElseAction)
                alertController.addAction(freeAction)
                alertController.addAction(finishedAction)
            }
            
            if let _ = dsCalArray[indexPath.row] as? Appointment {
                let rescheduleAction = UIAlertAction(title: "Reschedule", style: .Default) { (action) in
                }
                
                alertController.addAction(rescheduleAction)
                alertController.addAction(deleteAction)
            }
            
            if let _ = dsCalArray[indexPath.row] as? Free {
                let addApptAction = UIAlertAction(title: "Add appointment", style: .Default) { (action) in
                }
                
                alertController.addAction(addApptAction)
            }
            self.presentViewController(alertController, animated: true, completion: nil)
        }
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
            if tmCopy.calendarArray[row][col] == tmCopy.calendarArray[row + 1][col] {
               return true
            }
            if let _ = tmCopy.calendarArray[row][col] as? Free {
                if let _ = tmCopy.calendarArray[row + 1][col] as? Free {
                return true
                }
            }
        }
        return false
    }
    
    // allocate elements from calendar array to cells in view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // giving cell information and telling where to find it
        let cell = tableView.dequeueReusableCellWithIdentifier("Daily Schedule Cell", forIndexPath: indexPath)
        if indexPath.row < dsCalArray.count {
            let task = dsCalArray[indexPath.row][dateLocationDay]
            
            if let temp = task as? Assignment {
                // take the minute location of end time of the previous task and the start time of the next task
                let tempTitle = task?.title
                
                temp.title = minInHrCoord(dsCalArray[indexPath.row - 1][dateLocationDay]!.dsCalAdjustedEndLocation + 1) + " - " + minInHrCoord(dsCalArray[indexPath.row + 1][dateLocationDay]!.dsCalAdjustedStartLocation) + ": \(tempTitle!)"
                
                cell.textLabel?.text = temp.title
                temp.title = tempTitle!
                return cell
            }
            
            
            else {
                cell.textLabel?.text = task?.title
            }
            
            return cell
            
            /*
            if let temp = task as? Free {
                temp.title = "Free"
                cell.textLabel?.text = minInHrCoord(task.dsCalAdjustedStartLocation) + " - " + minInHrCoord(task.dsCalAdjustedEndLocation + 1) + ": \(task.title)"
                return cell
            }
            
            // if it's an assignment, deal with different member variables
            if let temp = task as? Assignment {
                // take the minute location of end time of the previous task and the start time of the next task
                let tempTitle: String = task.title
                
                temp.title = minInHrCoord(dsCalArray[indexPath.row - 1].dsCalAdjustedEndLocation + 1) + " - " + minInHrCoord(dsCalArray[indexPath.row + 1].dsCalAdjustedStartLocation) + ": \(task.title)"
                print ("\(temp.title)")
                cell.textLabel?.text = temp.title
                
                temp.title = tempTitle
                return cell
            }
                
            // each cell aligns with indexpath.row as it progresses down
            
            else {
                cell.textLabel?.text = minInHrCoord(task.dsCalAdjustedStartLocation) + " - " + minInHrCoord(task.dsCalAdjustedEndLocation + 1) + ": \(task.title)"
            }
             */
        }
        else {
            cell.textLabel?.text = ""
            return cell
        }
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

        // make copy of tm to avoid pointer trouble
        tmCopy = taskManager.copy() as! TaskManager

        // wipe dsCalArray
        dsCalArray = [[Task?]]()
        
        // iterate through tmCopy's calArray
        for var k = 0; k < 28; ++k {
            // create otherDayCount every day you iterate through
            var otherDayIndex = 0
            
            for var i = 0; i < MINS_IN_DAY; ++i {
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
                tmCopy.calendarArray[i][k].dsCalAdjustedStartLocation = j
                tmCopy.calendarArray[i][k].dsCalAdjustedEndLocation = i
                
                addToDSCalArray(j, endCoor: i, dayCoor: k, oDRowIndex: otherDayIndex)

                if k > 0 {
                    otherDayIndex += 1
                }
            }
        }
    }
    
   
    
    func addToDSCalArray(startCoor: Int, endCoor: Int, dayCoor: Int, oDRowIndex: Int) {
        
        if let temp = tmCopy.calendarArray[endCoor][dayCoor] as? Free {
            // alter object's title
            temp.title = minInHrCoord(temp.dsCalAdjustedStartLocation) + " - " + minInHrCoord(temp.dsCalAdjustedEndLocation + 1) + ": Free"
            addTaskToDSCal(dayCoor, taskIn: temp, oDIndexIn: oDRowIndex)
            
        }
    
        if let temp = tmCopy.calendarArray[endCoor][dayCoor] as? Assignment {
            // save original title
            
            /*let titleTemp = temp.title

            temp.title = minInHrCoord(temp.dsCalAdjustedStartLocation) + " - " + minInHrCoord(temp.dsCalAdjustedEndLocation + 1) + ": " + titleTemp
            */
            
            addTaskToDSCal(dayCoor, taskIn: temp, oDIndexIn: oDRowIndex)
        }
        
        if let temp = tmCopy.calendarArray[endCoor][dayCoor] as? Appointment {
            let titleTemp = temp.title
            temp.title = minInHrCoord(temp.dsCalAdjustedStartLocation) + " - " + minInHrCoord(temp.dsCalAdjustedEndLocation + 1) + ": " + titleTemp
            addTaskToDSCal(dayCoor, taskIn: temp, oDIndexIn: oDRowIndex)
        }
    }
    
    func copyAtRow(arr: [[Task?]], row: Int) -> [Task?] {
        var newRow = [Task?]()
        newRow = createRowWith28Nils()
        for var k = 0; k < 28; ++k {
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
        for var i = 0; i < 28; ++i {
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
                for var k = 0; k < 28; ++k {
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
    
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if (segue.identifier == "Change Date") {
    segue.destinationViewController.title = "Change Date"
    }
    }
    */
}