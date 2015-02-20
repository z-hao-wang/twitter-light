//
//  TimelineViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweets:[Tweet]?
    var refreshControl:UIRefreshControl?
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        self.performSegueWithIdentifier("composeSegue", sender: self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetch", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl!, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetTableViewCell
        let tweet = tweets![indexPath.row]
        cell.userName.text = tweet.user!.name
        cell.tweetText.text = tweet.text
        cell.timeStamp.text = tweet.createdTimeToNow()
        cell.profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageURL!))
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
    }


}
