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
    
    @IBOutlet weak var taskLabel: UILabel!
    // FIXME: need to display all the elements of task for viewer's pleasure

    override func viewDidLoad() {
        super.viewDidLoad()
    
    // Do any additional setup after loading the view.

        if let appointment = task as? Appointment {
        taskLabel.text  = "Due on \(appointment.startTime)"
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
