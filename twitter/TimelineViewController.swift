//
//  TimelineViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, replyDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets:[Tweet]?
    var refreshControl:UIRefreshControl?
    var replyTweet: Tweet?
    var menuVC: MenuViewController!
    var currentViewController: UIViewController!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    var menuBeginOrigin:CGPoint!
    var panGestureBeginOrigin:CGPoint!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var timelineView: UIView!
    var delegate:swipeDelegate?
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        replyTweet = nil
    self.performSegueWithIdentifier("composeSegue", sender: self)
    }
    
    func navToProfile(user: User?) {
        self.delegate?.navigateToProfile(true, user: user)
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    @IBAction func doSwipe(panGestureRecognizer: UIPanGestureRecognizer) {
        self.delegate?.processSwipe(panGestureRecognizer)
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
