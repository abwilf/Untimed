//
//  CustomRepeatTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/22/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class CustomRepeatTableViewController: AddAppointmentTableViewController {
    
    // self.view
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            if cell.accessoryType == UITableViewCellAccessoryType.None {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                addedAppointment.repeatDaysIndex[indexPath.row] = true
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
                addedAppointment.repeatDaysIndex[indexPath.row] = false
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
