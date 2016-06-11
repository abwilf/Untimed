//
//  AddTimeViewController.swift
//  Untimed
//
//  Created by Keenan Tullis on 6/11/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class AddTimeViewController: UIViewController {
    
    @IBOutlet weak var stepperLabel: UILabel!

    @IBAction func AddTimeStepper(sender: UIStepper) {
        stepperLabel.text = "\(String(sender.value)) hours"
    }
    
    
}
