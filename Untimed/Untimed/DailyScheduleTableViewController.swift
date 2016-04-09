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

    
    @IBAction func reloadPressed(sender: UIBarButtonItem) {
        taskManager.loadFromDisc()
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
    
    // unwind segue deleting task from delete in singletasktableviewcontroller
    @IBAction func unwindAndDeleteTask(sender: UIStoryboardSegue) {
        if let sttvc = sender.sourceViewController as? SingleTaskTableViewController {
            let index = sttvc.index
            taskManager.deleteTaskAtIndex(index)
             tableView.reloadData()
        }
    }
    
    
    func putApptsAndFreeTimeInCalArray() {
        
        let currentDate = NSDate()
        // FIXME: calendarArray is now a member variable of taskmanager
        // #3: put appointments in the calendar array by pulling them from tasks array
        for var i = 0; i < taskManager.tasks.count; ++i {
            
            // if object == appointment, assign to calendarArray
            if let appt = taskManager.tasks[i] as? Appointment {
                
                //Puts appointment in to correct spot in array
    
                    let diffDateComponentsHour = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: appt.startTime, toDate: appt.endTime, options: NSCalendarOptions.init(rawValue: 0))
                    
                    let diffDateComponentsDay = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: appt.endTime, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
                    
                    let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
                    
                    let startTimeComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: appt.startTime)
                    
                    /*
                    let endTimeComponents = NSCalendar.currentCalendar().component(unitFlags, fromDate: appt.endTime)
    */
                
                
                    for var i = 0; i < 12; ++i {

                        // NOTE: possibly limited to two dates within the same month
                        if startTimeComponents.hour == i + 8 {
                            for var k = 0; k < (diffDateComponentsHour.hour); ++k {
                                taskManager.calendarArray[i + k][diffDateComponentsDay.day] = appt
                            }
                        }
                    }
                

            }
        }
        
        
        // declare free object
        let freeTime: Free = Free()
        
        // put free object in all slots not occupied by appointment
        
        for var i = 0; i < 12; ++i {
            for var j = 0; j < 28; ++j {
               
                // if the spot is taken by an appointment ignore it
                if let _ = taskManager.calendarArray[i][j] as? Appointment {
                    }
                
                // otherwise, allocate a free object to it
                else {
                    taskManager.calendarArray[i][j] = freeTime
                }
            }
        }
    }
    
    
    
    // #5 FROM TO-DO LIST
    
    // add up the amount of free objects before each assignment's due date
    
    // 1. find the two places in the calendar array (start and end)
    // 2. iterate through and count up the number of Free objects in the array in that time period
    // 3. return the count of all those free objects
    
    
    // MAKE THIS A MEMBER VARIABLE
    // FIXME: needs assignment argument and return type
    
    
    func calcFreeTimeUntilDue(assgt: Assignment) {
        let currentDate = NSDate()
        /*
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let dueDateComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: assgt.dueDate)
        let currentDateComponents = NSCalendar.currentCalendar().component(unitFlags, fromDate: currentDate)
        */
        
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: currentDate, toDate: assgt.dueDate, options: NSCalendarOptions.init(rawValue: 0))
        
        
        // make due date just a date (no time)
        
        // FIXME: magic number!! (12)
        for var i = 0; i < 12; ++i {
            // FIXME: only works if two dates are within the same month
            for var j = 0; j < (diffDateComponents.day); ++j {
                // FIXME: how to check if task is of subclass free?
                // get all tasks that are due today
                if let free = taskManager.calendarArray[i][j] as? Free {
                    assgt.amountOfFreeHoursBeforeDueDate += 1
                }
            }
        }
    }
    

    
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        var assignNext = Task()
        
        func getNextAssignment() {
        for var i = 0; i < taskManager.tasks.count; ++i {
            if ((taskManager.tasks[i] as? Assignment) && (taskManager.tasks[i + 1] as? Assignment) (taskManager.tasks[i].amountOfFreeTimeBeforeDueDate - taskManager.tasks[i].timeNeeded) < (taskManager.tasks[i + 1].amountOfFreeTimeBeforeDueDate - taskManager.tasks[i + 1].timeNeeded) {
                
                assignNext = taskManager.tasks[i]
            }
            return assignNext
    }
    
*/
        
        

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

    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 12 hour days = 12 rows
        return 12
    }
    */

    

    // #7 FROM TO DO LIST: allocate elements from calendar array to cells in view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        // if row = 0, allocate first cell as 8 - 9 am: \(task.name)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Daily Schedule Cell", forIndexPath: indexPath)
        
        // only doing it for today (col = 0)
        let task = taskManager.calendarArray[indexPath.row][0]
        
        // 8 - 9 am block
        if indexPath.row == 0 {
            cell.textLabel?.text = "8-9 a.m.: \(task.title)"
        }
        
        // 9 - 10 block
        if indexPath.row == 1 {
            cell.textLabel?.text = "9-10 a.m.: \(task.title)"
        }
        
        // 10 - 11 block
        if indexPath.row == 2 {
            cell.textLabel?.text = "10-11 a.m.: \(task.title)"
        }
        
        // 11 - 12 block
        if indexPath.row == 3 {
            cell.textLabel?.text = "11 a.m. - 12 p.m.: \(task.title)"
        }
        
        // 12 - 1 block
        if indexPath.row == 4 {
            cell.textLabel?.text = "8-9 a.m.: \(task.title)"
        }
        
        // 1 - 2 block
        if indexPath.row == 5 {
            cell.textLabel?.text = "1-2 p.m.: \(task.title)"
        }
        
        // 2 - 3 block
        if indexPath.row == 6 {
            cell.textLabel?.text = "2-3 p.m.: \(task.title)"
        }
        
        // 3 - 4 block
        if indexPath.row == 7 {
            cell.textLabel?.text = "3-4 p.m.: \(task.title)"
        }
        
        // 4 - 5 block
        if indexPath.row == 8 {
            cell.textLabel?.text = "4-5 p.m.: \(task.title)"
        }
        
        // 5 - 6 block
        if indexPath.row == 9 {
            cell.textLabel?.text = "5-6 p.m.: \(task.title)"
        }
        
        // 6 - 7 block
        if indexPath.row == 10 {
            cell.textLabel?.text = "6-7 p.m.: \(task.title)"
        }
        
        // 7-8 block
        if indexPath.row == 11 {
            cell.textLabel?.text = "7-8 p.m.: \(task.title)"
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // delete from dailysched view
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            // delete and save
            taskManager.deleteTaskAtIndex(indexPath.row)
            tableView.reloadData()
            }
        }
    
    }


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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


