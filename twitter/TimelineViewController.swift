//
//  TimelineViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

let menuAnimationDuration = 0.2

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, replyDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets:[Tweet]?
    var refreshControl:UIRefreshControl?
    var replyTweet: Tweet?
    var menuVC: MenuViewController!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    var menuBeginOrigin:CGPoint!
    var panGestureBeginOrigin:CGPoint!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var timelineView: UIView!
    
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        replyTweet = nil
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    
    @IBAction func doSwipe(panGestureRecognizer: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.translationInView(self.containerView)
        let velocity = panGestureRecognizer.velocityInView(self.containerView)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            //println("Gesture began at: \(point)")
            menuBeginOrigin = menuVC.view.center
            panGestureBeginOrigin = point
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(menuVC.view.center.x)")
            menuVC.view.center.x = menuBeginOrigin.x + point.x - panGestureBeginOrigin.x
            if menuVC.view.center.x < -menuVC.view.frame.width / 2.0 {
                menuVC.view.center.x = -menuVC.view.frame.width / 2.0
            }
            self.timelineView.center.x = menuVC.view.center.x + menuVC.view.frame.width
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            //snap it on to the side
            if velocity.x < 0 {
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    self.menuVC.view.center.x = -self.menuVC.view.frame.width / 2.0
                }, completion: { (done: Bool) -> Void in
                    
                })
                
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    self.timelineView.center.x = self.timelineView.frame.width / 2.0
                    }, completion: { (done: Bool) -> Void in
                        
                })

            } else {
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    self.menuVC.view.center.x = self.menuVC.view.frame.width / 2.0
                }, completion: { (done: Bool) -> Void in
                        
                })
                UIView.animateWithDuration(menuAnimationDuration, animations: { () -> Void in
                    self.timelineView.center.x = self.timelineView.frame.width * 1.5
                }, completion: { (done: Bool) -> Void in
                        
                })
            }
        }
    }
    
    func fetch() {
        TwitterClient.getInstance.fetchTweetsWithCompletion { (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets
                self.tableView.reloadData()
                if let rc = self.refreshControl {
                    self.refreshControl!.endRefreshing()
                }
            }
        }
    }
    
    func tweetSent(notification: NSNotification) {
        let newTweet:Dictionary<String, Tweet> = notification.userInfo as Dictionary<String, Tweet>
        self.tweets!.insert(newTweet["tweet"]!, atIndex: 0)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuVC = storyboard?.instantiateViewControllerWithIdentifier("hamburgerMenu") as MenuViewController
        self.containerView.addSubview(menuVC.view)
        menuVC.view.center.x = -menuVC.view.frame.size.width / 2.0
        fetch()
        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetch", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl!, atIndex: 0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tweetSent:", name: newTweetNotification, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetTableViewCell
        cell.tweet = tweets![indexPath.row]
        cell.delegate = self
        cell.update()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func onReply(tweet: Tweet) {
        replyTweet = tweet
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let isCell = (sender is TweetTableViewCell ? true : false)
        if isCell {
            var detailsViewController = segue.destinationViewController as TweetDetailViewController
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                detailsViewController.tweet = self.tweets![indexPath.row]
            }
        }
        
        let isCompose = (sender is UIViewController ? true : false)
        if (isCompose) {
            var vc = segue.destinationViewController as ComposeViewController
            vc.replyTweet = replyTweet
        }
    }


}
