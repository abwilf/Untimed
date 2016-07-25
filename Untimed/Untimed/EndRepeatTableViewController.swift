//
//  EndRepeatTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/22/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class EndRepeatTableViewController: AddAppointmentTableViewController {
    
    @IBAction func didChangeEndDate(sender: UIDatePicker) {
        addedAppointment.repeatData.endRepeatDate = sender.date
    }
    
    var showDatePicker = false
    var currentRow = 0
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let optionIndex = addedAppointment.endRepeatIndex
        let initialIndexPath = NSIndexPath(forRow: optionIndex, inSection: 0)

        let initialCell = tableView.cellForRowAtIndexPath(initialIndexPath)
        initialCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    override func tableView(tableView: UITableView,
                            heightForRowAtIndexPath indexPath: NSIndexPath)
                            -> CGFloat {
        
        switch indexPath.row {
        case 0, 1:
            return 44
        default:
            if showDatePicker == true {
                return 235
            }
            else {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let optionIndex = addedAppointment.endRepeatIndex
        
        if indexPath.row == optionIndex {
            return
        }
        else if indexPath.row == 0 {
            let oldIndexPath = NSIndexPath(forRow: optionIndex, inSection: 0)
            let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath)
            oldCell!.accessoryType = UITableViewCellAccessoryType.None
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            addedAppointment.endRepeatIndex = 0
            
            showDatePicker = false
            tableView.reloadData()
        }
        else if indexPath.row == 1 {
            let oldIndexPath = NSIndexPath(forRow: optionIndex, inSection: 0)
            let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath)
            oldCell!.accessoryType = UITableViewCellAccessoryType.None
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            addedAppointment.endRepeatIndex = 1
            
            showDatePicker = true
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}