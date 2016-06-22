//
//  NewsDetailVewController.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-08.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    var detailItem: NewsStory? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.readMoreButton?.hidden = false;
            if let title = self.titleLabel {
                title.text = detail.title
            }
            if let description = self.descriptionLabel {
                let attrStr = try! NSAttributedString(
                    data: detail.content.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                    options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil)
                description.attributedText = attrStr
                description.font = UIFont.systemFontOfSize(15)
            }
            if let dateLabel = self.dateLabel {
                if let date = detail.date {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = .MediumStyle
                    dateFormatter.timeStyle = .NoStyle
                    dateLabel.text = dateFormatter.stringFromDate(date)
                } else {
                    dateLabel.text = "No Date"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        if self.detailItem == nil {
            self.titleLabel.text = "Select a News Item in the Sidebar to View Details"
            self.readMoreButton?.hidden = true
            self.dateLabel.text = ""
            self.descriptionLabel.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ReadMoreButton(sender: UIButton) {
        if let url = detailItem?.URL {
            UIApplication.sharedApplication().openURL(url)
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
