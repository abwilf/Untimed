//
//  AddClassTableViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 7/26/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddClassTableViewController: UITableViewController {
    
    var addedClass = Class()
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changedTitle(sender: UITextField) {
        if let name = sender.text {
            addedClass.title = name
        }
    }
    
    @IBAction func editingDidEnd(sender: UITextField) {
        // get rid of keyboard
        sender.resignFirstResponder()
    }
}