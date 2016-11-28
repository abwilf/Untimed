//
//  AddViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 4/4/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if click on Assignment
        if (segue.identifier == "Add Assignment") {
            segue.destinationViewController.title = "Add Assignment"
        }
        
        // if click on Appointment
        if (segue.identifier == "Add Appointment") {
            segue.destinationViewController.title = "Add Appointment"
        }
        
        
    }

}
