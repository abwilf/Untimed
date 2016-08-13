//
//  TimeCompletedViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/9/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class TimeCompletedViewController: UIViewController {
    
    // 0 = cal, 1 = hamburger
    var sendingViewControllerIndicator: Int = 0
    
    var task: Task? = nil

    var hoursCompleted: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var switchLabelFromHamburger: UILabel!

    @IBOutlet weak var switchLabel: UILabel!
    
    @IBAction func stepperClickedFromHamburger(sender: UIStepper) {
        switchLabelFromHamburger.text = "\(String(sender.value)) hours"
        hoursCompleted = sender.value
    }
    @IBAction func stepperClicked(sender: UIStepper) {
        switchLabel.text = "\(String(sender.value)) hours"
        hoursCompleted = sender.value
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
