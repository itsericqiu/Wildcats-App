//
//  SpiritViewController.swift
//  Wildcats
//
//  Created by Eric Qiu on 2016-06-13.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit
import AVFoundation

class SpiritViewController: UIViewController {
    
    // Grab the path, make sure to add it to your project!
    var wildCat = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("WildCat", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    var animation = CABasicAnimation(keyPath: "position")
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = try! AVAudioPlayer(contentsOfURL: wildCat)
        audioPlayer.prepareToPlay()
        self.tapRecognizer.addTarget(self, action: #selector(SpiritViewController.screenTapped(_:)))
    }
    
    override func viewDidAppear(animated: Bool) {
        audioPlayer.prepareToPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func screenTapped(sender: UITapGestureRecognizer) {
        if sender.state == .Ended{
            spirit()
        }
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            spirit()
        }
    }
    
    func spirit() {
        audioPlayer.play()
        
        // animation
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(logoView.center.x - 10, logoView.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(logoView.center.x + 10, logoView.center.y))
        logoView.layer.addAnimation(animation, forKey: "position")
        print ("Spirit Activated")
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
