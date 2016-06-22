//
//  RSSItem.swift
//  AlamofireRSSParser
//
//  Created by Donald Angelillo on 3/1/16.
//  Copyright © 2016 Donald Angelillo. All rights reserved.
//

import Foundation

public class RSSItem: CustomStringConvertible {
    public var title: String? = nil
    public var link: String? = nil
    
    public var itemDescription: String? = nil {
        didSet {
            if let itemDescription = self.itemDescription {
                self.imagesFromDescription = self.imagesFromHTMLString(itemDescription)
            }
        }
    }
    
    public var guid: String? = nil
    public var author: String? = nil
    public var comments: String? = nil
    public var source: String? = nil
    public var pubDate: NSDate? = nil
    public var mediaThumbnail: String? = nil;
    public var mediaContent: String? = nil;
    public var imagesFromDescription: [String]? = nil;

    public var description: String {
        return "\ttitle: \(self.title)\n\tlink: \(self.link)\n\titemDescription: \(self.itemDescription)\n\tguid: \(self.guid)\n\tauthor: \(self.author)\n\tcomments: \(self.comments)\n\tsource: \(self.source)\n\tpubDate: \(self.pubDate)\nmediaThumbnail: \(self.mediaThumbnail)\nmediaContent: \(self.mediaContent)\nimagesFromDescription: \(self.imagesFromDescription)\n\n"
    }
    
    private func imagesFromHTMLString(htmlString: String) -> [String] {
        let htmlNSString = htmlString as NSString;
        var images: [String] = Array();
        
        do {
            let regex = try NSRegularExpression(pattern: "(https?)\\S*(png|jpg|jpeg|gif)", options: [NSRegularExpressionOptions.CaseInsensitive])
        
            regex.enumerateMatchesInString(htmlString, options: [NSMatchingOptions.ReportProgress], range: NSMakeRange(0, htmlString.characters.count)) { (result, flags, stop) -> Void in
                if let range = result?.range {
                    images.append(htmlNSString.substringWithRange(range))  //because Swift ranges are still completely ridiculous
                }
            }
        }
        
        catch {
            
        }
        
        return images;
    }
    
    /*
-(NSArray *)imagesFromHTMLString:(NSString *)htmlstr {
    NSMutableArray *imagesURLStringArray = [[NSMutableArray alloc] init];

    NSError *error;

    NSRegularExpression *regex = [NSRegularExpression
    regularExpressionWithPattern:@"(https?)\\S*(png|jpg|jpeg|gif)"
    options:NSRegularExpressionCaseInsensitive
    error:&error];

    [regex enumerateMatchesInString:htmlstr
    options:0
    range:NSMakeRange(0, htmlstr.length)
    usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
    [imagesURLStringArray addObject:[htmlstr substringWithRange:result.range]];
    }];

    return [NSArray arrayWithArray:imagesURLStringArray];
    }
    */
}