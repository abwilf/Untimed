//
//  CaptureListViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 8/13/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class CaptureListViewController: UIViewController {

    var storedText: String = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setTextView()
        
        
    }
    
    
    @IBOutlet var textView: UITextView!
    
    func setTextView() {
        textView.text = storedText
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        storedText = textView.text
    }

}
