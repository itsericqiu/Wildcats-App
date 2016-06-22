//
//  HomeViewController.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-07.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var latestNewsLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateDate()
        updateNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        updateDate()
        updateNews()
    }
    
    func updateDate() {
        dateFormatter.dateFormat = "EEEE"
        self.dayLabel.text = dateFormatter.stringFromDate(NSDate())
        dateFormatter.dateFormat = "MMMM d, yyyy"
        self.dateLabel.text = dateFormatter.stringFromDate(NSDate())
    }
    
    func updateNews() {
        if let story = loadNews() {
            let attrStr = try! NSAttributedString(
                data: story.content.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            latestNewsLabel.attributedText = attrStr
            latestNewsLabel.font = UIFont.systemFontOfSize(15)
            latestNewsLabel.textColor = UIColor.whiteColor()
            print("latest news loaded to home page")
        }
    }
    
    // MARK: NSCoding
    func loadNews() -> NewsStory? {
        if let latest =  NSKeyedUnarchiver.unarchiveObjectWithFile(NewsStory.ArchiveURL.path!) as? [NewsStory] {
            return latest[0]
        } else {
            return nil
        }
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