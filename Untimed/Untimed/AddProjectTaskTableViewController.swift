//
//  ProjectTaskTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 8/1/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddProjectTaskTableViewController: UITableViewController {
    var addedProjTask = ProjectTask()
    var classes: [Class] = []
    var classIndex: Int = 0
    var projectAndAssnArrIndex: Int = 0
    

    @IBOutlet weak var switchLabel: UILabel!
    
    @IBAction func stepperPressed(sender: UIStepper) {
        addedProjTask.timeNeeded = Double(sender.value)
        switchLabel.text = "\(String(sender.value)) hours"
    }
    
    @IBAction func didEditTitle(sender: UITextField) {
        if let newTitle = sender.text {
            addedProjTask.title = newTitle
        }
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didEnterDueDate(sender: UIDatePicker) {
        var newDueDate = NSDate()
        newDueDate = sender.date
        addedProjTask.dueDate = newDueDate
        sender.minimumDate = NSDate()
    }
    
   
    
    @IBAction func didFinishEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func unwindFromPickAClass(sender: UIStoryboardSegue) {
        if let pactvc =
            sender.sourceViewController as? PickAClassTableViewController {
            classIndex = pactvc.index
        }
    }
    
    @IBAction func unwindFromPickAProject(sender: UIStoryboardSegue) {
        if let paptvc =
            sender.sourceViewController as? PickAProjectTableViewController {
            _ = paptvc.indexChosen
            _ = classes[classIndex]
//            let indexInProjAndAssn = classSelected.projOnlyArray[projOnlyIndex].indexInProjAndAssnArr
//            projectAndAssnArrIndex = indexInProjAndAssn!
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // send the classes array through to the pick a class view controller
        if (segue.identifier == "Pick A Class 2") {
            let destinationViewController = segue.destinationViewController as! PickAClassTableViewController
            destinationViewController.classArr = classes
        }
        
        if segue.identifier == "Pick a Project" {
            let destinationViewController = segue.destinationViewController as! PickAProjectTableViewController
            destinationViewController.classObj = classes[classIndex]
        }
    }
    
}
