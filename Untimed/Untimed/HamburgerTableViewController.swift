//
//  HamburgerTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/11/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class HamburgerTableViewController: UITableViewController {

    var tmObj = TaskManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tmObj.loadFromDisc()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        tmObj = TaskManager()
      //  assert(tmObj.dailyListArray.count != 0, "")
        tmObj.loadFromDisc()
        //assert(tmObj.dailyListArray.count != 0, "")
    }
    @IBAction func tasksButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("To Tasks", sender: sender)
    }
    
    @IBAction func calButtonpressed(sender: UIButton) {
        self.performSegueWithIdentifier("To Cal", sender: sender)
    }
    
    @IBAction func markCompletePressed(sender: UIButton) {
        self.performSegueWithIdentifier("Accountability Segue", sender: sender)
    }
    
    @IBAction func unwindFromSettings(sender: UIStoryboardSegue) {
        if let stvc = sender.sourceViewController as? SettingsTableViewController {
            tmObj.firstWorkingHour = stvc.fwh
            tmObj.lastWorkingHour = stvc.lwh
            
            tmObj.setSettingsArray()
            
            tmObj.save()
            
            assert(tmObj.settingsArray.count == 2, "\n\n\nsave and load settingsArray from disc failed\n\n")
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindAndChangeDate(sender: UIStoryboardSegue) {
        if let cdvc = sender.sourceViewController as? ChangeDateViewController {
            tmObj.selectedDate = cdvc.newDate
            tmObj.dateLocationDay = tmObj.selectedDate.calendarDayIndex()
            tmObj.save()
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromCaptureList(sender: UIStoryboardSegue) {
        if let clvc = sender.sourceViewController as? CaptureListViewController {
            tmObj.captureListText = clvc.storedText
            
            tmObj.save()
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromAccountabilityToHamburger (sender: UIStoryboardSegue) {
        if let atvc = sender.sourceViewController as? AccountabilityTableViewController {
            // maybe get rid of tasks
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromDailyListToHamburger(sender: UIStoryboardSegue) {
        if let dlvc = sender.sourceViewController as? DailyListViewController {
            
            tmObj.dailyListArray[tmObj.dateLocationDay] = dlvc.dailyList
            
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Accountability Segue") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! AccountabilityTableViewController
            
            targetController.focusTasks = tmObj.focusTasksArr
        }
        
        if (segue.identifier == "To Cal") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! DailyScheduleTableViewController
            
            targetController.taskManager = tmObj
        }
        
        if (segue.identifier == "To Tasks") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! TaskTableTableViewController
            
            targetController.tmObj = tmObj
        }
        
        if (segue.identifier == "To Capture List") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! CaptureListViewController
            
            targetController.storedText = tmObj.captureListText
        }
        
        if (segue.identifier == "To Daily List") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! DailyListViewController
            
            // modify dailyList var based on datelocation day
            
            if let temp = tmObj.dailyListArray[tmObj.dateLocationDay] {
                targetController.dailyList = temp
            }
            
            else {
                targetController.dailyList = ""
            }
        }
    }
    
}
