//
//  PickAClassTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 7/27/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class PickAClassTableViewController: UITableViewController {

    var classArr: [Class] = []
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classArr.count
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        if let indexChosen = tableView.indexPathForSelectedRow?.row {
            // send projAndAssnArray to the next view controller based on which project is selected
            index = indexChosen
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Class Cell", forIndexPath: indexPath)
        
        if indexPath.row < classArr.count {
            cell.textLabel?.text = classArr[indexPath.row].title
        }
        
        else {
            cell.textLabel?.text = ""
        }
        
        return cell
    }
}
