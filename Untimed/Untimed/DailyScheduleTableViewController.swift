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
    @IBAction func unwindToDailySchedulePageAndAddTask(sender: UIStoryboardSegue)
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
    @IBAction func unwindToDailySchedulePageAndDeleteTask(sender: UIStoryboardSegue) {
        if let sttvc = sender.sourceViewController as? SingleTaskTableViewController {
            let index = sttvc.index
            taskManager.deleteTaskAtIndex(index)
        }
    }
    

    
    // the calendar - a 2d array with rows (time of day- row 0 is 8-9am) and cols (date starting at first day you open the app)
    var calendarArray = [[Task]]()
    
    func putApptsAndFreeTimeInCalArray() {
        
        // put appointments in the calendar array by pulling them from tasks array
        for var i = 0; i < taskManager.tasks.count; ++i {
            
            // if object == appointment, assign to calendarArray
            if let appt = taskManager.tasks[i] as? Appointment {
                
                //Puts appointment in to correct spot in array
                for var i = 0; i < 12; ++i {
                    if appt.startTime == i + 8 && appt.endTime == i + 9 {
                        calendarArray.insert([appt], atIndex: i)
                    }
                }

            }
        }
        
        
        // declare free object
        let freeTime: Free = Free()
        
        
        // put free object in all slots not occupied by appointment
        for var i = 0; i < calendarArray.count; ++i {
            for var j = 0; j < calendarArray.count; ++j {
               
                // if the spot is taken by an appointment ignore it
                if let isFree = calendarArray[i][j] as? Appointment {
                    
                    // Sets correct slots equal to free in the array
                    calendarArray.insert([isFree], atIndex: i)
                    }
                
                // otherwise, allocate a free object to it
                else {
                    calendarArray[i][j] = freeTime
                }
            }
        }
    }
    

    
    // add up the amount of time before each assignment's due date
    var timeBeforeDueDate = 0
    func calcTimeUntilDue(){
        
        for var i = 0; i < taskManager.tasks.count; ++i {
    
    // if object == appointment, assign to calendarArray
            if let assn = taskManager.tasks[i] as? Assignment {
                let currentDate = NSDate()
 //               var timeBeforeDueDate = assn.dueDate - currentDate //FIX THIS!!
            }
        }
    }
    
    // allocate assignments based on the difference between their freeTimeBeforeDueDate and the timeNeeded
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

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

    
    // this is where our allocation goes! look at the same spot in tasktabletable for formatting ideas
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Daily Schedule Cell", forIndexPath: indexPath)

        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
