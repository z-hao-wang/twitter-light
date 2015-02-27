//
//  MenuViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/24/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var menuBeginOrigin:CGPoint!
    var panGestureBeginOrigin:CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSwipe(panGestureRecognizer: UIPanGestureRecognizer) {
        if let parentVC = self.parentViewController {
            let point = panGestureRecognizer.translationInView(parentVC.view)
            let velocity = panGestureRecognizer.velocityInView(parentVC.view)
            
            if panGestureRecognizer.state == UIGestureRecognizerState.Began {
                //println("Gesture began at: \(point)")
                self.menuBeginOrigin = self.view.center
                panGestureBeginOrigin = point
            } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
                println("Gesture changed at: \(self.view.center.x)")
                self.view.center.x = menuBeginOrigin.x + point.x - panGestureBeginOrigin.x
                if self.view.center.x < -self.view.frame.width / 2.0 {
                    self.view.center.x = -self.view.frame.width / 2.0
                }
                //self.timelineView.center.x = menuVC.view.center.x + menuVC.view.frame.width / 2.0
            } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
                //snap it on to the side
                if velocity.x < 0 {
                    UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                        self.view.center.x = -self.view.frame.width / 2.0
                        }, completion: { (done: Bool) -> Void in
                            
                    })
                } else {
                    UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                        self.view.center.x = self.view.frame.width / 2.0
                        }, completion: { (done: Bool) -> Void in
                            
                    })
                }
            }

        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("menuCell") as MenuTableViewCell
        switch indexPath.row {
        case 0:
            cell.menuLabel.text = "Home"
        case 1:
            cell.menuLabel.text = "Profile"
        case 2:
            cell.menuLabel.text = "Mentions"
        default:
            cell.menuLabel.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
