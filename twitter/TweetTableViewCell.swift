//
//  TweetTableViewCell.swift
//  twitter
//
//  Created by Hao Wang on 2/19/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

protocol replyDelegate {
    func onReply(tweet: Tweet)
}
class TweetTableViewCell: UITableViewCell {

    var delegate: replyDelegate?
    var tweet: Tweet?
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var profileImage: UIImageView!
    
        @IBOutlet weak var timeStamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }
    
    func update() {
        if let tweetUn = tweet {
            self.userName.text = tweetUn.user!.name
            self.tweetText.text = tweetUn.text
            self.timeStamp.text = tweetUn.createdTimeToNow()
            self.profileImage.setImageWithURL(NSURL(string: tweetUn.user!.profileImageURL!))
            toggleRetweetStatus(false)
            if (tweet?.retweeted != nil) {
                if tweet?.retweeted > 0 {
                    toggleRetweetStatus(true)
                }
            }
            toggleFavStatus(false)
            if (tweet?.favorited != nil) {
                if tweet?.favorited > 0 {
                    toggleFavStatus(true)
                }
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toggleRetweetStatus(on: Bool) {
        let img = UIImage(named: on ? "retweet_on" : "retweet") as UIImage?
        retweetButton.setImage(img, forState: .Normal)
    }
    
    func toggleFavStatus(on: Bool) {
        let img = UIImage(named: on ? "favorite_on" : "favorite") as UIImage?
        favoriteButton.setImage(img, forState: .Normal)
    }

    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.getInstance.favoriteWithId(tweet!.id!, complete: { (error) -> () in
            if error == nil {
                //success
                println("fav success")
                self.toggleFavStatus(true)
            } else {
                println("fav failed \(error)")
            }
        })
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.getInstance.reTweetWithId(tweet!.id!, complete: { (error) -> () in
            if error == nil {
                //success
                self.toggleRetweetStatus(true)
            } else {
                println("retweet failed")
            }
        })
    }
    @IBAction func onReply(sender: AnyObject) {
        delegate?.onReply(tweet!)
    }
}
