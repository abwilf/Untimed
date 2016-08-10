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
    
    var focusIndicator: Bool = false
    
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexChosen = tableView.indexPathForSelectedRow?.row {
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
