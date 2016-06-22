//
//  CalendarDetailViewController.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-12.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit

class CalendarDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var button: UIButton!
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle

        if let detail = self.detailItem {
            let allDay = detail.allDay ?? false
            self.button?.hidden = false;
            if allDay {
                dateFormatter.timeStyle = .NoStyle
            } else {
                dateFormatter.timeStyle = .ShortStyle
            }
            
            if let title = self.titleLabel {
                title.text = detail.summary
            }
            if let start = self.startDateLabel {
                if let startDate = detail.start {
                    if allDay {
                        start.text = dateFormatter.stringFromDate(startDate)
                    } else {
                        start.text = "Starts: " + dateFormatter.stringFromDate(startDate)
                    }
                } else {
                    start.text = "Starts: [No Date]"
                }
            }
            if let end = self.endDateLabel {
                if detail.allDay! {
                    end.text = "All Day"
                } else if let endDate = detail.end {
                    end.text = "Ends: " + dateFormatter.stringFromDate(endDate)
                } else {
                    end.text = "Ends: [No Date]"
                }
            }
            if detail.attachment != nil && detail.attachmentURL != nil {
                self.button.titleLabel!.text = "See Attachment: " + (detail.attachment ?? nil)!
            }
        }
    }
    
    @IBAction func SeeMoreButton(sender: UIButton) {
        if detailItem?.attachment != nil {
            if let url = detailItem?.attachmentURL {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        if let url = detailItem?.link {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        if detailItem == nil {
            self.titleLabel.text = "Select an Event in the Sidebar to View Details"
            self.startDateLabel.text = ""
            self.endDateLabel.text = ""
            self.button?.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
