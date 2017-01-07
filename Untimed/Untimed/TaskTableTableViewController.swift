//
//  TaskTableTableViewController.swift
//  Untimed
//
//  Created by Alex Wilf on 3/30/16.
//  Copyright © 2016 EECS-ellent. All rights reserved.
//

import UIKit

class TaskTableTableViewController: UITableViewController {
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    var tmObj = TaskManager()
    
    // whether in focus or view mode
    var focusIndicator = false
    
    // index in the cal array of the working block you're attaching the focus to
    var wbIndex: Int = 0
    var dateLocationDay: Int = 0
    
    func resetForTesting () {
        tmObj.classArray = []
        tmObj.appointmentArray = []
        tmObj.save()
        assert(false, "Resetting tmObj in TaskTable")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if focusIndicator == false {
            tmObj.loadFromDisc()
        }
    }
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        
        // use only for testing
//        resetForTesting()
        
        super.viewWillAppear(animated)
        
        // for hambuger icon
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        tableView.reloadData()
    }

    @IBAction func cancelFocusButtonPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func unwindAndAddTask(sender: UIStoryboardSegue)
    {
        // save from add class
        if let actvc = sender.sourceViewController as?
            AddClassTableViewController {
            
            tmObj.addClass(actvc.addedClass)
            
            tmObj.save()
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindAndDeleteTask(sender: UIStoryboardSegue) {
        if let sttvc =
            sender.sourceViewController as? SingleTaskTableViewController {
            _ = sttvc.index
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromPAndA(sender: UIStoryboardSegue) {
        if let paatvc =
            sender.sourceViewController as? ProjectsAndAssignmentsTableViewController {
            
            // replace class array object with modified one
            tmObj.classArray[paatvc.classArrOrigIndex] = paatvc.selectedClass
            
            // save
            tmObj.save()
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromSingleTaskViewer(sender: UIStoryboardSegue) {
        if let _ =
            sender.sourceViewController as? SingleTaskTableViewController {
            tmObj.loadFromDisc()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromProjectFocus(sender: UIStoryboardSegue) {
        if let paatvc =
            sender.sourceViewController as? ProjectsAndAssignmentsTableViewController {
            tmObj = paatvc.tmObj
            
            tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        //return the number of rows we want in that section
        if section == 0 {
            // return number of rows we want in this section (all tasks)
            return tmObj.classArray.count
            
        }
            
        else {
            return 0
        }
    }
    
    
    // indexpath is a location where the tableView is looking to put an object
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        // "Task Cell" is identifier of the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Task Cell",
                                                               forIndexPath: indexPath)
        
        if indexPath.row < tmObj.classArray.count {
            // Configure the cell
            let task = tmObj.classArray[indexPath.row]
            cell.textLabel?.text = task.title
             
   
            cell.detailTextLabel?.text = ""
        }
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if click on add task button
        if (segue.identifier == "Add Assignment Segue") {
            
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            
            let targetController = destinationNavigationController.topViewController as! AddAssignmentTableViewController
            
            targetController.classes = tmObj.classArray
        }
        
        if (segue.identifier == "Add Project Segue") {
            
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
           
            let targetController = destinationNavigationController.topViewController as! AddProjectTableViewController

            targetController.classes = tmObj.classArray
        }
        
        if (segue.identifier == "Add Project Task Segue") {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! AddProjectTaskTableViewController
            targetController.classes = tmObj.classArray
        }
        
        if (segue.identifier == "To Projects And Assignments") {
            
            let destinationNavController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavController.topViewController as! ProjectsAndAssignmentsTableViewController
            targetController.title = "Projects and Assignments"
            
            if let index = tableView.indexPathForSelectedRow?.row {
                // send projAndAssnArray to the next view controller based on which project is selected
                targetController.selectedClass = tmObj.classArray[index]
                targetController.classArrOrigIndex = index
                targetController.tmObj = tmObj
            }
        }
        
        
        if (segue.identifier == "To Project Focus") {
            
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! ProjectsAndAssignmentsTableViewController
            
            if let index = tableView.indexPathForSelectedRow?.row {
                // send projAndAssnArray to the next view controller based on which project is selected
                targetController.selectedClass = tmObj.classArray[index]
                
                targetController.tmObj = tmObj
                
                // focus, not view mode
                targetController.focusIndicator = focusIndicator
                
                // set working block index
                targetController.wbIndex = wbIndex
                targetController.dateLocationDay = dateLocationDay
                
            }
        }
    }
    
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            tmObj.deleteClassAtIndex(classIndex: indexPath.row)
            
            tmObj.save()
            
            tableView.reloadData()
        }
    }
    
}