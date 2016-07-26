//
//  RepeatTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/22/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class RepeatTableViewController: UITableViewController {
    
    var currentCategory: NSIndexPath? = nil
    var taskCategories: NSArray? = nil
    
    // initialize this value to addedAppointment.repeatOptionsIndex
    var optionIndex: Int = 0
        
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        var initialIndexPath = NSIndexPath(forRow: optionIndex, inSection: 0)
        if optionIndex < 5 {
        }
        else {
            initialIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        }
        let initialCell = tableView.cellForRowAtIndexPath(initialIndexPath)
        initialCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {

            if indexPath.row == optionIndex {
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
                
            else {
                let oldIndexPath = NSIndexPath(forRow: optionIndex, inSection: 0)
                let newCell = tableView.cellForRowAtIndexPath(indexPath)
                if newCell!.accessoryType == UITableViewCellAccessoryType.None {
                    newCell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                    optionIndex = indexPath.row
                    print(optionIndex)
                }
                let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath)
                oldCell!.accessoryType = UITableViewCellAccessoryType.None
                // FIXME: this is causing problems
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        else if indexPath.section == 1 {
            if optionIndex == 5{
                return
            }
            else {
                let oldIndexPath = NSIndexPath(forRow: optionIndex, inSection: 0)
                let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath)
                oldCell!.accessoryType = UITableViewCellAccessoryType.None
                
                let newCell = tableView.cellForRowAtIndexPath(indexPath)
                newCell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                optionIndex = 5
            }
        }
    }
        
//        func resetChecks() {
//            for i in 0..<tableView.numberOfRowsInSection(0) {
//                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) {
//                    cell.accessoryType = .None
//                }
//            }
//        }
        
//        if indexPath.section == 0 {
//            
//            let catIndex = self.indexOfAccessibilityElement(UITableViewCell)
//            
//            if catIndex == indexPath.row {
//                return
//            }
//            
//            let oldIndexPath = NSIndexPath(forRow: catIndex, inSection: 0)
//            
//            let newCell = tableView.cellForRowAtIndexPath(indexPath)
//            
//            if newCell?.accessoryType == UITableViewCellAccessoryType.None {
//                newCell!.accessoryType = UITableViewCellAccessoryType.Checkmark
//            }
//            
//            let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath)
//            
//            if oldCell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
//                oldCell!.accessoryType = UITableViewCellAccessoryType.None
//            }
//            
//        }
        
//        if indexPath.section == 0 {
//            let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//            if cell.accessoryType == UITableViewCellAccessoryType.None {
//                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//            }
//            else {
//                cell.accessoryType = UITableViewCellAccessoryType.None
//            }
//            
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}