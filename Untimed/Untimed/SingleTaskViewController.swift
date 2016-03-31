//
//  SingleTaskViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 3/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class SingleTaskViewController: UIViewController {
    
    // this is being set by the prepareforSegue function in TaskTableTable
    var task = Task()
    
    // FIXME: need to display all the elements of task for viewer's pleasure

    override func viewDidLoad() {
        super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
