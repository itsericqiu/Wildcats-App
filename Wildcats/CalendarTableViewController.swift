//
//  CalendarTableViewController.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-10.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class CalendarTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var detailViewController: CalendarDetailViewController? = nil
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"
        
        // set self as delegate for split view
        let splitViewController = self.splitViewController
        let navigationController = splitViewController!.viewControllers[splitViewController!.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem()
        splitViewController?.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // set controller for detail view
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1]) as? CalendarDetailViewController
        }
        
        // load Calendar
        if let savedEvents = loadEvents() {
            self.events = savedEvents
        }
        self.tableView.reloadData()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return events.count
        default:
            fatalError()
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarCell", forIndexPath: indexPath)
        // Configure the cell...
        let event = events[indexPath.row]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        if event.allDay! {
            // Don't show a start time if all day event
            dateFormatter.timeStyle = .NoStyle
        } else {
            dateFormatter.timeStyle = .ShortStyle
        }
        
        cell.textLabel!.text = event.summary
        
        if let startDate =  event.start {
            cell.detailTextLabel!.text = dateFormatter.stringFromDate(startDate)
            print("converted " + String(startDate) + " to " + cell.detailTextLabel!.text!)
        }
        else {
            cell.detailTextLabel?.text = "No Date"
        }
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calendarShowDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CalendarDetailViewController
                // build NewStory to send to Detail View
                let event = events[indexPath.row]
                controller.detailItem = event
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? CalendarDetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return true
    }
    
    // MARK: NSCoding
    func loadEvents() -> [Event]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Event.ArchiveURL.path!) as? [Event]
    }
}

extension NSDate {
    struct Date {
        static let formatterISO8601: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
            formatter.locale = NSLocale.currentLocale()
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            return formatter
        }()
    }
    var formattedISO8601: String { return Date.formatterISO8601.stringFromDate(self) }
}
