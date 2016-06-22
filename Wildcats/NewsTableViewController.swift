//
//  NewsTableViewController.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-06.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit
import FeedParser

// WSMT news RSS Feed URL
let feedURL = NSURL(string: "https://wstmntfeed.commons.hwdsb.on.ca/feed/")!

class NewsTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var detailViewController: NewsDetailViewController? = nil
    var feed = [NewsStory]()
    
    // Whenever this view appears on screen
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        
        
        
        // set self as delegate for split view
        let splitViewController = self.splitViewController
        let navigationController = splitViewController!.viewControllers[splitViewController!.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem()
        splitViewController?.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // set controller for detail view
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1]) as? NewsDetailViewController
        }
        
        // load News
        if let savedNews = loadNews() {
            self.feed = savedNews
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            // either unwraps optional value or returns 0 by defult if null (nil in Swift)
            return self.feed.count ?? 0
        default:
            fatalError()
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.feed[indexPath.row].title ?? "[no title]"
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newsShowDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! NewsDetailViewController
                // build NewStory to send to Detail View
                let story = self.feed[indexPath.row]
                controller.detailItem = story
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? NewsDetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return true
    }
    
    // MARK: NSCoding
    func loadNews() -> [NewsStory]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(NewsStory.ArchiveURL.path!) as? [NewsStory]
    }

}
