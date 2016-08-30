//
//  DailyListViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class DailyListViewController: UIViewController {

    var dailyList: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet var textView: UITextView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = dailyList
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dailyList = textView.text
    }

}
