//
//  PickAProjectTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/2/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class PickAProjectTableViewController: UITableViewController {

    var classObj = Class()
    var indexChosen = 0
    
    var focusIndicator: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return classObj.projOnlyArray.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Project Cell", forIndexPath: indexPath)
//
//        cell.textLabel?.text = classObj.projOnlyArray[indexPath.row].title
//
//        return cell
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexSelected = tableView.indexPathForSelectedRow?.row {
            // send back index selected in projOnly array
            indexChosen = indexSelected
        }
    }

}
