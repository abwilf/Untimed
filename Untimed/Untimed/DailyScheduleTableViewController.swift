
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
    
    var dsCalArray: [[Task?]] = []
    var printedDSCalArray: [[Task?]] = []

    // create counting variables for allocation to tableview
    var startLocation = 0
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    func hourMinuteStringFromNSDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .MediumStyle

        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h:mma"

        let string = dateFormatter.stringFromDate(date)
        return string
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
            taskManager.save()
            tableView.reloadData()
        }
    }
    
    // update selectedDate with changed date value
    @IBAction func unwindAndChangeDate(sender: UIStoryboardSegue) {
        if let cdvc = sender.sourceViewController as? ChangeDateViewController {
            selectedDate = cdvc.newDate
            taskManager.dateLocationDay = selectedDate.calendarDayIndex()
            print (taskManager.dateLocationDay)
            taskManager.save()
            taskManager.loadFromDisc()
            taskManager.allocateTime()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromPickFocus(sender: UIStoryboardSegue) {
        
        if let paatvc = sender.sourceViewController as? ProjectsAndAssignmentsTableViewController {

            taskManager = paatvc.tmObj
            taskManager.save()
            tableView.reloadData()
        }
        
        if let pttvc = sender.sourceViewController as? ProjTasksTableViewController {
            pttvc.updateFocusTasks()
            taskManager = pttvc.tmObj
            taskManager.save()
            taskManager.loadFromDisc()
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
        taskManager.dateLocationDay = selectedDate.calendarDayIndex()
        
        taskManager.save()
        
        if taskManager.dateLocationDay == 0 {
            title = "Today"
        }
        
        if taskManager.dateLocationDay == 1 {
            title = "Tomorrow"
        }
        
        if taskManager.dateLocationDay > 1 {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let printedDate = dateFormatter.stringFromDate(selectedDate)
            title = "\(printedDate)"
        }
    }
    
    // action sheets
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // final actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let deleteActionSingleInstance = UIAlertAction(title: "Only this instance", style: .Destructive) { (action) in
            if let appt = self.taskManager.calendarArray[self.taskManager.dateLocationDay][indexPath.row] as? Appointment {
                self.taskManager.deleteSingleInstanceOf(appointment: appt)
                self.taskManager.clearWorkingBlocksThatDoNotHaveFocusesAtDayIndex(dayIndex: self.taskManager.dateLocationDay)
                self.taskManager.save()
                tableView.reloadData()
            }
        }
        let deleteActionAllInstances = UIAlertAction(title: "All instances of this appointment", style: .Destructive) { (action) in
            if let appt = self.taskManager.calendarArray[self.taskManager.dateLocationDay][indexPath.row] as? Appointment {
                // make sure this is working properly
                self.taskManager.deleteAllInstancesOf(appointment: appt)
                self.taskManager.clearWorkingBlocksThatDoNotHaveFocusesAtDayIndex(dayIndex: self.taskManager.dateLocationDay)
                self.taskManager.save()
                tableView.reloadData()
            }
        }
        let deleteAppointment = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            if let appt = self.taskManager.calendarArray[self.taskManager.dateLocationDay][indexPath.row] as? Appointment {
                // make sure this is working properly
                self.taskManager.removeSingleApptInstanceFromCalArray(appointment: appt)
                self.taskManager.removeApptFromApptArr(appointment: appt)
                self.taskManager.clearWorkingBlocksThatDoNotHaveFocusesAtDayIndex(dayIndex: self.taskManager.dateLocationDay)
                self.taskManager.save()
                tableView.reloadData()
            }
        }
        
        // alert controllers
        // action sheet
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // for non-repeating appointments
        let warningControllerSingle = UIAlertController(title: nil, message: "Are you sure you want to delete this appointment?", preferredStyle: .Alert)
        
        // for repeating appointments
        let warningControllerRepeating = UIAlertController(title: nil, message: "Would you like to delete only this appointment, or all future instances of this appointment?", preferredStyle: .Alert)
        
        let deleteActionSingle = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            self.taskManager.calArrayDescriptionForDay(0)
            // delete warning
            self.presentViewController(warningControllerSingle, animated: true) {
            }
        }
        
        let deleteActionRepeating = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            // delete warning
            self.presentViewController(warningControllerRepeating, animated: true) {
            }
        }

        alertController.addAction(cancelAction)
        warningControllerSingle.addAction(cancelAction)
        warningControllerRepeating.addAction(cancelAction)
        
        warningControllerSingle.addAction(deleteAppointment)
        warningControllerRepeating.addAction(deleteActionSingleInstance)
        warningControllerRepeating.addAction(deleteActionAllInstances)
    
        if let appt = taskManager.calendarArray[taskManager.dateLocationDay][indexPath.row] as? Appointment {
            if appt.doesRepeat {
                alertController.addAction(deleteActionRepeating)
            }
            else if appt.isRepetition {
                alertController.addAction(deleteActionRepeating)
            }
            else {
                alertController.addAction(deleteActionSingle)
            }
        }
        
        if let _ = taskManager.calendarArray[taskManager.dateLocationDay][indexPath.row] as? Free {
            let addApptAction = UIAlertAction(title: "Add appointment", style: .Default) { (action) in
            }
            
            alertController.addAction(addApptAction)
        }
   
        if let wbObj = taskManager.calendarArray[taskManager.dateLocationDay][indexPath.row] as? WorkingBlock {
            let selectFocusAction = UIAlertAction(title: "Select Focus", style: .Default) { (action) in self.performSegueWithIdentifier("Select Focus Segue", sender: self)
            }
            
            let writeInFocusAction = UIAlertAction(title: "Write In Focus", style: .Default) { (action) in
                // Create the alert controller.
                var alert = UIAlertController(title: "Write In Focus", message: "Enter Task Name", preferredStyle: .Alert)
                
                // Add the text field. You can configure it however you need.
                alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                    textField.text = ""
                })
                
                // Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    let textField = alert.textFields![0] as UITextField
                    
                    //print("Text field: \(textField.text)")
                    
                    // FIXME: temporary until we get the task list sorted out!
                    
                    // create a task with that name to put in the wbObj's focus array
                    let newTaskObj = Task()
                    
                    newTaskObj.title = textField.text! as String
                    
                    wbObj.focusArr = []
                    
                    wbObj.focusArr += [newTaskObj]
                    wbObj.hasFocus = true

                    print (wbObj.focusArr[0].title)
                    self.taskManager.save()
                    tableView.reloadData()
                }))
                
                // Present the alert.
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            let clearFocusAction = UIAlertAction(title: "Clear Focus", style: .Destructive) { (action) in
                wbObj.focusArr = [];
                self.taskManager.save();
                tableView.reloadData()
            }

            alertController.addAction(clearFocusAction)
            alertController.addAction(selectFocusAction)
            alertController.addAction(writeInFocusAction)
            
        }
    
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func reloadPressed(sender: UIBarButtonItem) {
        // re-allocate
        taskManager.loadFromDisc()
        taskManager.allocateTime()
        tableView.reloadData()
    }
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // for testing only
    func clearSelectedDate() {
        taskManager.selectedDate = NSDate()
        taskManager.save()
        taskManager.dateLocationDay = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let now = NSDate()
        let nowValForComparison = now.getTimeValForComparison()
        let lastWorkingValForComparison = taskManager.lastWorkingHour.getTimeValForComparison()
        if nowValForComparison > lastWorkingValForComparison {
            if !(taskManager.focusTasksArr.isEmpty) {
                self.performSegueWithIdentifier("Accountability Segue", sender: self)
            }
        }
        
        taskManager.loadFromDisc()
    
        // FIXME: for testing only
//        clearSelectedDate()

        // set selectedDate
        selectedDate = taskManager.selectedDate
        
        // set working minutes from saved settings array
        setWorkingHours()
        
        // for hamburger icon
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    func setWorkingHours() {
        assert(taskManager.settingsArray.count == 2, "tm settings arr is wrong")
        taskManager.firstWorkingHour = taskManager.settingsArray[0]
        taskManager.lastWorkingHour = taskManager.settingsArray[1]
    }
    
    override func viewWillDisappear(animated: Bool) {
       // print (taskManager.calendarArray[0][0].title)
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
        taskManager.allocateWorkingBlocksAtIndex(dayIndex: taskManager.dateLocationDay)
        return taskManager.calendarArray[taskManager.dateLocationDay].count
    }
    
    func thereExistsAnApptOutsideWorkingDay() -> Bool {
        
        return false
    }
    
    override func tableView(tableView: UITableView,
                            heightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
            
            let task = taskManager.calendarArray[taskManager.dateLocationDay][indexPath.row]
            let start_time = task.startTime.getTimeValForComparison()
            let end_time = task.endTime.getTimeValForComparison()
            
            // find hour value difference
            let hour_diff = (end_time - start_time) / 100
            
            return CGFloat(44 * hour_diff)
    }
    
    // allocate elements from calendar array to cells in view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // giving cell information and telling where to find it
        let cell = tableView.dequeueReusableCellWithIdentifier("Daily Schedule Cell", forIndexPath: indexPath)
        
        var color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        if indexPath.row < taskManager.calendarArray[selectedDate.calendarDayIndex()].count {
            let task = taskManager.calendarArray[taskManager.dateLocationDay][indexPath.row]
        
            var label = ""
            var subLabel = ""
            
            if let temp = task as? Free {
                label = "\(hourMinuteStringFromNSDate(temp.startTime)) - \(hourMinuteStringFromNSDate(temp.endTime)): Free"
            }
            
            if let temp = task as? Appointment {
                let title = temp.title
                label = "\(hourMinuteStringFromNSDate(temp.startTime)) - \(hourMinuteStringFromNSDate(temp.endTime)): \(title)"
                color = UIColor(red: 200/255, green: 75/255, blue: 25/255, alpha: 0.5)
            }
            
            if let temp = task as? WorkingBlock {
                label = "\(hourMinuteStringFromNSDate(temp.startTime)) - \(hourMinuteStringFromNSDate(temp.endTime)): Working Block"
                color = UIColor(red: 0, green: 100/255, blue: 165/255, alpha: 0.5)
                if temp.focusArr.count != 0 {
                    subLabel = "Focus: "
                    for i in 0..<temp.focusArr.count {
                        
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
            }
            
            cell.textLabel?.text = label
            cell.detailTextLabel?.text = subLabel
            cell.textLabel?.backgroundColor = color;
            cell.detailTextLabel?.backgroundColor = color;
            cell.backgroundColor = color;
            
            return cell
        }
        else {
            assert(false)
            cell.textLabel?.text = ""
            return cell
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if (segue.identifier == "Change Date") {
            segue.destinationViewController.title = "Change Date"
        }
        
        if (segue.identifier == "DS To Settings") {
            // dealing with Nav controller in between views
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! SettingsTableViewController
            
            // pass in minute properties.
            targetController.fwh = taskManager.firstWorkingHour
            targetController.lwh = taskManager.lastWorkingHour
        }
        
        if (segue.identifier == "Select Focus Segue") {
            // dealing with Nav controller in between views
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! TaskTableTableViewController
            
            // pass in tmObj
            targetController.tmObj = taskManager
            
            if let indexSelected = tableView.indexPathForSelectedRow?.row {
                targetController.wbIndex = indexSelected
                targetController.dateLocationDay = taskManager.dateLocationDay
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