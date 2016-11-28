
//
//  AddAppointmentTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/5/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddAppointmentTableViewController: UITableViewController {
    
    // created task that we will modify
    var addedAppointment = Appointment()
    
    @IBOutlet weak var repeatDetail: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        repeatDetail?.text = addedAppointment.repeatOptionsArray[addedAppointment.repeatOptionsIndex]
        //print(repeatDetail?.text)
    }
    

    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

    // did change start date
    
        // modifies end date minimum

    @IBAction func didChangeEditingAssignmentTitle(sender: UITextField) {
        // if able to unwrap, set it equal
        if let newTitle = sender.text {
            addedAppointment.title = newTitle
        }
    }
    
    
    // outlet modifying minimum end date so it can't be before start date
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var newStartDate = NSDate()

    // update start time
    @IBAction func didEnterStartDate(sender: UIDatePicker) {
        sender.minimumDate = NSDate()
        newStartDate = sender.date
        addedAppointment.startTime = newStartDate
        
        // update end date minimum to start date
        endDatePicker.minimumDate = newStartDate
        addedAppointment.endTime = endDatePicker.date
    }
    

    // update appointment's end time
    @IBAction func didEnterEndDate(sender: UIDatePicker) {
        addedAppointment.endTime = endDatePicker.date
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func textFieldDoneEditing(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // send the classes array through to the pick a class view controller
        if (segue.identifier == "Repeat Segue") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            
            let targetController = destinationNavigationController.topViewController as! RepeatTableViewController
            
            targetController.optionIndex = addedAppointment.repeatOptionsIndex
        }
    }
    
    @IBAction func unwindAndUpdateRepeatOptionsIndex(sender: UIStoryboardSegue) {
        // save from add assignment via unwind
        if let rtvc =
            sender.sourceViewController as? RepeatTableViewController {
            addedAppointment.repeatOptionsIndex = rtvc.optionIndex
            addedAppointment.repeatDaysIndex = rtvc.repeatDaysArr
        }
    }

    @IBAction func unwindAndUpdateCustomRepeatArray(sender: UIStoryboardSegue) {
        // save from add assignment via unwind
        if let crtvc =
            sender.sourceViewController as? CustomRepeatTableViewController {
            addedAppointment.repeatOptionsIndex = 4
            addedAppointment.repeatDaysIndex = crtvc.repeatDaysArray
        }
    }
}
