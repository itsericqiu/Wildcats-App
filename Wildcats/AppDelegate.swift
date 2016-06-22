//
//  AppDelegate.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-06.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit
import Alamofire
import FeedParser
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UITabBarController, UIApplicationDelegate {
    
    // pieces of calendar URL
    let calID: String = "hwdsb.on.ca_8qnc1fdsl7gppbv16frbsmr30g%40group.calendar.google.com"
    
    /*** PUT GOOGLE API KEY HERE ***/
    let apiKey: String = "{YOUR GOOGLE API KEY HERE}"
    let URLformat: String = "https://www.googleapis.com/calendar/v3/calendars/%@/events?orderBy=startTime&singleEvents=true&timeMin=%@&key=%@"
    // WSMT news RSS Feed URL
    let feedURL = NSURL(string: "https://wstmntfeed.commons.hwdsb.on.ca/feed/")!

    var window: UIWindow?
    var events = [Event]()
    var newsItems = [NewsStory]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor(red: 77/255.0, green: 166/255.0, blue: 255/255.0, alpha: 1.0)
        let moreController = self.moreNavigationController
        moreController.navigationBar.barStyle = .Black
        moreController.navigationBar.barTintColor = UIColor(red: 0.0, green: 40/255, blue: 85/255, alpha: 1.0)
        moreController.navigationBar.tintColor = UIColor(red: 65/255, green: 162/255, blue: 1.0, alpha: 1.0)
        updateCalendar()
        updateNews()
        tabBarController?.customizableViewControllers = nil
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        updateCalendar()
        updateNews()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func primaryViewControllerForCollapsingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
        return splitViewController.viewControllers[0]
    }
    
    override func tabBar(tabBar: UITabBar, didEndCustomizingItems items: [UITabBarItem], changed: Bool) {
        var tabBarTagOrder = NSArray()
        for item in items {
            tabBarTagOrder = tabBarTagOrder.arrayByAddingObject(item.tag)
        }
        NSUserDefaults.standardUserDefaults().setObject(tabBarTagOrder, forKey: "TabBarOrder")
        print("saved updated tab order")
    }
    
    func updateCalendar() {
        // default is to ask for events after Jan. 1, 2016 (because the calendar doesn't have any recent events :/
        let minTimeDefault = "2016-01-01T00:00:00-0" + String(abs(NSTimeZone.systemTimeZone().secondsFromGMT/3600)) + ":00"
        let curMinTime = NSDate().formattedISO8601
        // generate URL for WMT Calendar
        let calURL: URLStringConvertible = String(format: URLformat, calID, minTimeDefault, apiKey)
        
        Alamofire.request(.GET, calURL, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let rawJSON = response.result.value {
                    print("JSON: \(rawJSON)")
                    let json = JSON(rawJSON)
                    for (_, event):(String, JSON) in json["items"] {
                        // build instance of event
                        let temp = Event()
                        // summary
                        if let summary = event["summary"].string {
                            temp.summary = summary
                        } else {
                            temp.summary = "No Title"
                        }
                        // start/end date/dateTime
                        if let start = event["start"]["date"].string {
                            temp.start = dateFormatter.dateFromString(start)
                            temp.end = dateFormatter.dateFromString(event["end"]["date"].string!)
                            temp.allDay = true
                        }
                        else if let start = event["start"]["dateTime"].string {
                            temp.start = NSDate.Date.formatterISO8601.dateFromString(start)
                            print("Converted " + start + " to " + String(temp.start))
                            temp.end = NSDate.Date.formatterISO8601.dateFromString(event["end"]["dateTime"].string!)
                            print("Converted " + event["end"]["dateTime"].string! + " to " + String(temp.end))
                            temp.allDay = false
                        } else {
                            continue
                        }
                        // link
                        if let link = event["htmlLink"].string {
                            temp.link = NSURL(string: link)
                        }
                        if let attachment = event["attachments"]["0"]["title"].string {
                            temp.attachment = attachment
                        }
                        if let attachmentURL = event["attachments"]["0"]["fileUrl"].string {
                            temp.attachmentURL = NSURL(string: attachmentURL)
                        }
                        
                        // add to events list
                        self.events.append(temp)
                    }
                    self.saveEvents()
                }
        }
    }
    
    func updateNews() {
        Alamofire.request(.GET, feedURL).responseData() { (response) -> Void in
            if let rawFeed: NSData = response.result.value {
                FeedParser(data: rawFeed).parse() { (result) in
                    if let items = result.rssFeed?.items {
                        for story in items {
                            self.newsItems.append(NewsStory(story: story))
                        }
                        self.saveNews()
                    }
                }
            }
        }
    }
    
    // NSCoding
    
    func saveEvents() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.events, toFile: Event.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save events...")
        } else {
            print("Successfully saved events:")
            print(self.events)
        }
    }
    
    func saveNews() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.newsItems, toFile: NewsStory.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save news...")
        } else {
            print("Successfully saved news:")
            print(self.newsItems)
        }
    }
}

