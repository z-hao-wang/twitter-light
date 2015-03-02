//
//  MenuViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/24/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

//menu animation duration
let menuAnimationDuration = 0.2
let MenuRightGap:CGFloat = 50.0

protocol swipeDelegate {
    func processSwipe(panGestureRecognizer: UIPanGestureRecognizer)
    func navigateToProfile(animated: Bool, user: User?)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, swipeDelegate {

    @IBOutlet var viewContainer: UIView! //The view container. the position should never change
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var currentViewBeginOrigin:CGPoint!
    var panGestureBeginOrigin:CGPoint!
    var delegate:swipeDelegate?
    var timeLineViewController: TimelineViewController!
    var profileViewController: ProfileViewController!
    var mentionsViewController: MentionsViewController!
    var currentViewController: UIViewController!
    var menuItems = ["Home", "Profile", "Mentions"]
    var profileUser: User?
    var firstTimeLoad = false
    var currentViewMaxCenterX:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateTo(menuItems[0], animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        //set menu offset, hide it to the left
        screenName.text = User.currentUser!.name!
        profileImage.setImageWithURL(NSURL(string: User.currentUser!.profileImageURL!))
    }
    
    //This is the apropiate place to modify view attr after view is rendered 
    override func viewDidLayoutSubviews() {
        currentViewMaxCenterX = viewContainer.frame.width * 1.5 - MenuRightGap
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
            panGestureBeginOrigin = point
            currentViewBeginOrigin = currentViewController.view.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(point)")
            currentViewController.view.center.x = currentViewBeginOrigin.x + point.x - panGestureBeginOrigin.x
            if currentViewController.view.center.x > currentViewMaxCenterX {
                currentViewController.view.center.x = currentViewMaxCenterX
                panGestureBeginOrigin = point //reset start pos
            } else if currentViewController.view.center.x < viewContainer.center.x {
                currentViewController.view.center.x = viewContainer.center.x
                panGestureBeginOrigin = point //reset start pos
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            //snap it on to the side or center
            if velocity.x < 0 {
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    //put to center
                    self.currentViewController.view.center = self.viewContainer.center
                }, completion: { (done: Bool) -> Void in
                        
                })
            } else {
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    //put to right side
                    self.currentViewController.view.center.x = self.currentViewMaxCenterX
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
    
    func navigateToProfile(animated: Bool, user: User?) {
        profileUser = user
        navigateTo(menuItems[1], animated: animated)
    }
    
    func navigateTo(pageName: String, animated: Bool = false) {
        removeViewController()
        switch pageName {
            case menuItems[0]:
                if timeLineViewController == nil {
                    timeLineViewController = storyboard?.instantiateViewControllerWithIdentifier("timelineViewController") as TimelineViewController
                    timeLineViewController.delegate = self
                }
                currentViewController = timeLineViewController
                
            case menuItems[1]:
                if profileViewController == nil {
                    profileViewController = storyboard?.instantiateViewControllerWithIdentifier("profileViewController") as ProfileViewController
                    profileViewController.delegate = self
                    profileViewController.view.center.x = viewContainer.frame.width * 1.5
                }
                profileViewController.update(newUser: profileUser)
                currentViewController = profileViewController
            case menuItems[2]:
                if mentionsViewController == nil {
                    mentionsViewController = storyboard?.instantiateViewControllerWithIdentifier("mentionsViewController") as MentionsViewController
                    mentionsViewController.delegate = self
                    mentionsViewController.view.center.x = viewContainer.frame.width * 1.5
                }
                currentViewController = mentionsViewController
            default:
                return
        }
        addChildViewController(currentViewController)
        viewContainer.addSubview(currentViewController.view)
        if animated {
            self.currentViewController.view.center.x = viewContainer.frame.width * 1.5
            UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                self.currentViewController.view.center = self.viewContainer.center
            }, completion: { (done: Bool) -> Void in
            })
        } else {
            self.currentViewController.view.center = self.viewContainer.center
        }
        
    }
    
    @IBAction func doSwipe(panGestureRecognizer: UIPanGestureRecognizer) {
        processSwipe(panGestureRecognizer)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("menuCell") as MenuTableViewCell
        switch indexPath.row {
        case 0,1,2:
            cell.menuLabel.text = menuItems[indexPath.row]
        default:
            cell.menuLabel.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case 0,1,2:
                profileUser = User.currentUser //reset profile user regardless
                navigateTo(menuItems[indexPath.row], animated: true)
            default:
                return
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
