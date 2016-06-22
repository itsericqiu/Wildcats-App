//
//  Event.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-12.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding {
    var start: NSDate?
    var end: NSDate?
    var allDay: Bool?
    var link: NSURL?
    var summary: String?
    var attachment: String?
    var attachmentURL: NSURL?
    
    // Archive Paths for Persistent Data
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("events")
    
    // enum for property types
    struct PropertyKey {
        static let startKey = "start"
        static let endKey = "end"
        static let allDayKey = "allDay"
        static let linkKey = "link"
        static let summaryKey = "summary"
        static let attachmentKey = "attachment"
        static let attachmentURLKey = "attachmentURL"
    }
    
    override init() {
        super.init()
        start = nil
        end = nil
        allDay = nil
        link = nil
        summary = nil
    }
    
    init(start: NSDate, end: NSDate, allDay: Bool, link: NSURL, summary: String, attachment: String? = nil, attachmentURL: NSURL? = nil) {
        self.start = start
        self.end = end
        self.allDay = allDay
        self.link = link
        self.summary = summary
        
        if (attachmentURL != nil) && (attachment != nil) {
            self.attachment = attachment
            self.attachmentURL = attachmentURL
        } else {
            self.attachment = nil
            self.attachmentURL = nil
        }
        
        super.init()
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(start, forKey: PropertyKey.startKey)
        aCoder.encodeObject(end, forKey: PropertyKey.endKey)
        aCoder.encodeObject(allDay, forKey: PropertyKey.allDayKey)
        aCoder.encodeObject(link, forKey: PropertyKey.linkKey)
        aCoder.encodeObject(summary, forKey: PropertyKey.summaryKey)
        aCoder.encodeObject(attachment, forKey: PropertyKey.attachmentKey)
        aCoder.encodeObject(attachmentURL, forKey: PropertyKey.attachmentURLKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let start = aDecoder.decodeObjectForKey(PropertyKey.startKey) as! NSDate
        let end = aDecoder.decodeObjectForKey(PropertyKey.endKey) as! NSDate
        let allDay = aDecoder.decodeObjectForKey(PropertyKey.allDayKey) as! Bool
        let link = aDecoder.decodeObjectForKey(PropertyKey.linkKey) as! NSURL
        let summary = aDecoder.decodeObjectForKey(PropertyKey.summaryKey) as! String
        let attachment = aDecoder.decodeObjectForKey(PropertyKey.attachmentKey) as? String
        let attachmentURL = aDecoder.decodeObjectForKey(PropertyKey.attachmentURLKey) as? NSURL
        // Must call designated initializer.
        self.init(start: start, end: end, allDay: allDay, link: link, summary: summary, attachment: attachment, attachmentURL: attachmentURL)
    }
}