//
//  MentionsViewController.swift
//  twitter
//
//  Created by Hao Wang on 3/1/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var delegate: swipeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
        fetch()
    }

    @IBAction func doSwipe(sender: UIPanGestureRecognizer) {
        delegate?.processSwipe(sender)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetTableViewCell
        cell.tweet = tweets![indexPath.row]
        cell.update()
        return cell
    }
    
    func fetch() {
        TwitterClient.getInstance.fetchMentionsTimelineWithCompletion { (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets
                self.tableView.reloadData()
            }
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
