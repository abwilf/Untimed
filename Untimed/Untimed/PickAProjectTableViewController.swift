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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexSelected = tableView.indexPathForSelectedRow?.row {
            // send back index selected in projOnly array
            indexChosen = indexSelected
        }
    }

}
