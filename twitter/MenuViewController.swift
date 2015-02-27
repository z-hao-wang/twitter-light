//
//  MenuViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/24/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit
protocol swipeDelegate {
    func processSwipe(panGestureRecognizer: UIPanGestureRecognizer)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, swipeDelegate {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet var viewContainer: UIView! //The view container. the position should never change
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var menuBeginOrigin:CGPoint!
    var panGestureBeginOrigin:CGPoint!
    var delegate:swipeDelegate?
    var timeLineViewController: TimelineViewController!
    var profileViewController: ProfileViewController!
    var currentViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init timeline view controller
        /*timeLineViewController = storyboard?.instantiateViewControllerWithIdentifier("timelineViewController") as TimelineViewController
        addChildViewController(timeLineViewController)
        timeLineViewController.delegate = self
        viewContainer.addSubview(timeLineViewController.view)
        timeLineViewController.view.center = viewContainer.center
        currentViewController = timeLineViewController*/
        navigateTo("timeline")
    }
    
    override func viewWillAppear(animated: Bool) {
        //set menu offset, hide it to the left
        menuView.center.x = -menuView.frame.size.width / 2.0
    }
    
    override func viewDidAppear(animated: Bool) {
        //set menu offset, hide it to the left
        menuView.center.x = -menuView.frame.size.width / 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processSwipe(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.translationInView(self.viewContainer)
        let velocity = panGestureRecognizer.velocityInView(self.viewContainer)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            //println("Gesture began at: \(point)")
            menuBeginOrigin = menuView.center
            panGestureBeginOrigin = point
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(menuView.center.x)")
            menuView.center.x = menuBeginOrigin.x + point.x - panGestureBeginOrigin.x
            if menuView.center.x < -menuView.frame.width / 2.0 {
                menuView.center.x = -menuView.frame.width / 2.0
                panGestureBeginOrigin = point //reset start pos
            } else if menuView.center.x > menuView.frame.width / 2.0 {
                menuView.center.x = menuView.frame.width / 2.0
                panGestureBeginOrigin = point //reset start pos
            }
            timeLineViewController.view.center.x = menuView.center.x + menuView.frame.width
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            //snap it on to the side
            if velocity.x < 0 {
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    self.menuView.center.x = -self.menuView.frame.width / 2.0
                    }, completion: { (done: Bool) -> Void in
                        
                })
                
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    self.currentViewController.view.center.x = self.currentViewController.view.frame.width / 2.0
                    }, completion: { (done: Bool) -> Void in
                        
                })
                
            } else {
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    self.menuView.center.x = self.menuView.frame.width / 2.0
                    }, completion: { (done: Bool) -> Void in
                        
                })
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    self.currentViewController.view.center.x = self.currentViewController.view.frame.width * 1.5
                    }, completion: { (done: Bool) -> Void in
                        
                })
            }
        }
    }
    
    func removeViewController() {
        if self.currentViewController != nil {
            self.currentViewController.willMoveToParentViewController(nil)
            self.currentViewController.view.removeFromSuperview()
            self.currentViewController.didMoveToParentViewController(nil)
        }
    }
    
    func navigateTo(pageName: String, animated: Bool = false) {
        removeViewController()
        switch pageName {
            case "timeline":
                if timeLineViewController == nil {
                    timeLineViewController = storyboard?.instantiateViewControllerWithIdentifier("timelineViewController") as TimelineViewController
                    timeLineViewController.delegate = self
                }
                currentViewController = timeLineViewController
                
            case "profile":
                if profileViewController == nil {
                    profileViewController = storyboard?.instantiateViewControllerWithIdentifier("profileViewController") as ProfileViewController
                    profileViewController.delegate = self
                    profileViewController.view.center.x = viewContainer.frame.width * 1.5
                }
                currentViewController = profileViewController
            default:
                return
        }
        addChildViewController(currentViewController)
        viewContainer.addSubview(currentViewController.view)
        UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
            self.menuView.center.x = -self.menuView.frame.width / 2.0
            self.currentViewController.view.center = self.viewContainer.center
        }, completion: { (done: Bool) -> Void in
                
        })
    }
    
    @IBAction func doSwipe(panGestureRecognizer: UIPanGestureRecognizer) {
        processSwipe(panGestureRecognizer)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            navigateTo("profile", animated: true)
            //TODO: Animate it
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
