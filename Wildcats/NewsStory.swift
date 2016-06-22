//
//  NewsStory.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-09.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import Foundation
import FeedParser

class NewsStory: NSObject, NSCoding {
    var title: String
    var content: String
    var URL: NSURL?
    var date: NSDate?
    
    // Archive Paths for Persistent Data
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("newsItems")
    
    // enum for property types
    struct PropertyKey {
        static let titleKey = "title"
        static let contentKey = "content"
        static let URLKey = "URL"
        static let dateKey = "date"
    }
    
    init(title: String, description: String, URL: NSURL, date: NSDate) {
        self.title = title
        self.content = description
        self.URL = URL
        self.date = date
        
        super.init()
    }
    init(story: RSSFeedItem){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z" //nsdateformatter.com
        self.title = story.title ?? "no title"
        self.content = story.content?.contentEncoded ?? "no details available"
        self.URL = NSURL(string: story.link ?? "http://wstmntfeed.commons.hwdsb.on.ca")
        if let dateString = story.pubDate {
            self.date = dateFormatter.dateFromString(dateString) ?? nil
        }
        super.init()
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(content, forKey: PropertyKey.contentKey)
        aCoder.encodeObject(URL, forKey: PropertyKey.URLKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let content = aDecoder.decodeObjectForKey(PropertyKey.contentKey) as! String
        let URL = aDecoder.decodeObjectForKey(PropertyKey.URLKey) as! NSURL
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        
        // Must call designated initializer.
        self.init(title: title, description: content, URL: URL, date: date)
    }
}