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
    func refresh()
    func navToProfile(user: User?)
}
class TweetTableViewCell: UITableViewCell {

    var delegate: replyDelegate?
    var tweet: Tweet?
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var userName: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var favedCount: UILabel!
    @IBOutlet weak var retweetedCount: UILabel!
    
        @IBOutlet weak var timeStamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }
    
    @IBAction func didClickUserName(sender: UIButton) {
        delegate?.navToProfile(tweet?.user)
    }
    func update() {
        //clear
        if let tweetUn = tweet {
            self.userName.setTitle(tweetUn.user!.name, forState: .Normal)
            self.tweetText.text = tweetUn.text
            self.timeStamp.text = tweetUn.createdTimeToNow()
            if tweetUn.retweetCount != nil {
                self.retweetedCount.text = String(tweetUn.retweetCount!)
            } else {
                self.retweetedCount.text = "0"
            }
            if tweetUn.favouriteCount != nil {
                self.favedCount.text = String(tweetUn.favouriteCount!)
            } else {
                self.favedCount.text = "0"
            }
            self.profileImage.setImageWithURL(NSURL(string: tweetUn.user!.profileImageURL!))
            Utils.toggleRetweetStatus(false, button: retweetButton)
            if (tweet?.retweeted != nil) {
                if tweet?.retweeted! > 0 {
                    Utils.toggleRetweetStatus(true, button: retweetButton)
                }
            }
            Utils.toggleFavStatus(false, button: favoriteButton)
            if (tweet?.favorited != nil) {
                if tweet?.favorited! > 0 {
                    Utils.toggleFavStatus(true, button: favoriteButton)
                }
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /*
    func toggleRetweetStatus(on: Bool) {
        retweeted = on
        let img = UIImage(named: on ? "retweet_on" : "retweet") as UIImage?
        retweetButton.setImage(img, forState: .Normal)
    }
    
    func toggleFavStatus(on: Bool) {
        faved = on
        let img = UIImage(named: on ? "favorite_on" : "favorite") as UIImage?
        favoriteButton.setImage(img, forState: .Normal)
    }
*/
    @IBAction func onFavorite(sender: AnyObject) {
        if tweet!.favorited! == 0 {
        TwitterClient.getInstance.favoriteWithId(tweet!.id!, complete: { (response, error) -> () in
                if error == nil {
                    //success
                    println("fav success")
                    self.tweet!.favorited = 1
                    if self.tweet!.favouriteCount == nil {
                        self.tweet!.favouriteCount = 1
                    } else {
                        self.tweet!.favouriteCount! += 1
                    }
                    Utils.toggleFavStatus(true, button: self.favoriteButton)
                    self.delegate!.refresh()
                } else {
                    println("fav failed \(error)")
                }
            })
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if tweet!.retweeted! == 0 {
            TwitterClient.getInstance.reTweetWithId(tweet!.id!, complete: { (response, error) -> () in
                if error == nil {
                    //success
                    if self.tweet!.retweetCount == nil {
                        self.tweet!.retweetCount = 1
                    } else {
                        self.tweet!.retweetCount! += 1
                    }
                    self.tweet!.retweeted! = 1
                    Utils.toggleRetweetStatus(true, button: self.retweetButton)
                    self.delegate!.refresh()
                } else {
                    println("retweet failed")
                }
            })
        }
        
    }
    @IBAction func onReply(sender: AnyObject) {
        delegate?.onReply(tweet!)
    }
}
