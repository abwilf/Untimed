//
//  DailyScheduleTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/7/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class DailyScheduleTableViewController: UITableViewController {
    
    let taskManager = TaskManager()
    var dateLocationDay: Int = 0
    
    var selectedDate = NSDate() {
        didSet {
            updateTitle()
            
            // re-allocate
            taskManager.loadFromDisc()
            
            // problem may be here?!
            taskManager.allocateTime()
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
    
    
    func nsDateInCalFormat(nsDateObject: NSDate) ->
        (dayCoordinate: Int, hourCoordinate: Int) {
            var dayCoordinate: Int = 0
            var hourCoordinate: Int = 0
            
            let currentDate = NSDate()
            
            let componentsNowDay = NSCalendar.currentCalendar().components([.Day],
                                                                           fromDate: currentDate)
            let currentDay = componentsNowDay.day
            
            let componentsDueDateDay = NSCalendar.currentCalendar().components([.Day],
                                                                               fromDate: nsDateObject)
            let dueDateDay = componentsDueDateDay.day
            
            let componentsDueDateHour = NSCalendar.currentCalendar().components([.Hour],
                                                                                fromDate: nsDateObject)
            let dueDateHour = componentsDueDateHour.hour
            
            // day difference = place in col array
            let dayDiff = dueDateDay - currentDay
            
            // conversion factor
            let hourDiff = dueDateHour - 8
            
            dayCoordinate = dayDiff
            hourCoordinate = hourDiff
            
            // return minute block, not hour block
            return (dayCoordinate, hourCoordinate)
    }

    
    @IBAction func reloadPressed(sender: UIBarButtonItem) {
        // re-allocate
        taskManager.loadFromDisc()
        
        // problem may be here?!
        taskManager.allocateTime()
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
    
    
    
    
    // #5 FROM TO-DO LIST
    
    // add up the amount of free objects before each assignment's due date
    
    // 1. find the two places in the calendar array (start and end)
    // 2. iterate through and count up the number of Free objects in the array in that time period
    // 3. return the count of all those free objects
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 12 hour days = 12 rows
        return taskManager.cellsPerDay
    }
    
    // allocate elements from calendar array to cells in view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        // if row = 0, allocate first cell as 8 - 9 am: \(task.name)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Daily Schedule Cell", forIndexPath: indexPath)
        
        let task = taskManager.calendarArray[indexPath.row][dateLocationDay]
        
        // if Free, name Free
        if let _ = taskManager.calendarArray[indexPath.row][dateLocationDay] as? Free {
            // before 11-12 blocks
            if indexPath.row < 3 {
                cell.textLabel?.text = "\(indexPath.row + taskManager.FIRST_WORKING_HOUR)-\(indexPath.row + taskManager.FIRST_WORKING_HOUR + 1) am: Free"
            }
            
            // 11 - 12 block
            if indexPath.row == 3 {
                cell.textLabel?.text = "11 am-12 pm: Free"
            }
            
            // 12 - 1 block
            if indexPath.row == 4 {
                cell.textLabel?.text = "12-1 pm: Free"
            }
            
            // after 12 - 1 block.  there are 11 rows, and the rest is accounting for the 12-13 to 12-1 change
            if indexPath.row > 4 && indexPath.row <= 11 {
                cell.textLabel?.text = "\(indexPath.row + taskManager.FIRST_WORKING_HOUR - 12)- \(indexPath.row + taskManager.FIRST_WORKING_HOUR + 1 - 12) pm: Free"
            }
            return cell
        }
        
        
        // if not Free, make cell title name = task title.  This is before 11 - 12 block
        if indexPath.row < 3 {
            cell.textLabel?.text = "\(indexPath.row + taskManager.FIRST_WORKING_HOUR)-\(indexPath.row + taskManager.FIRST_WORKING_HOUR + 1) am: \(task.title)"
        }
        
        // 11 - 12 block
        if indexPath.row == 3 {
            cell.textLabel?.text = "11 am-12 pm: \(task.title)"
        }
        
        // 12 - 1 block
        if indexPath.row == 4 {
            cell.textLabel?.text = "12-1 pm: \(task.title)"
        }
        
        // after 12 - 1 block.  there are 11 rows, and the rest is accounting for the 12-13 to 12-1 change
        if indexPath.row > 4 && indexPath.row <= 11 {
            cell.textLabel?.text = "\(indexPath.row + taskManager.FIRST_WORKING_HOUR - 12)-\(indexPath.row + taskManager.FIRST_WORKING_HOUR + 1 - 12) pm: \(task.title)"
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        title = "Today"
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
    
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if (segue.identifier == "Change Date") {
    segue.destinationViewController.title = "Change Date"
    }
    }
    */
}