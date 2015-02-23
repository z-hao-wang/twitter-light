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
    var retweeted = false
    var faved = false
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
            Utils.toggleRetweetStatus(false, button: retweetButton)
            if (tweet?.retweeted != nil) {
                if tweet?.retweeted > 0 {
                    retweeted = true
                    Utils.toggleRetweetStatus(true, button: retweetButton)
                }
            }
            Utils.toggleFavStatus(false, button: favoriteButton)
            if (tweet?.favorited != nil) {
                if tweet?.favorited > 0 {
                    faved = true
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
        if !faved {
            TwitterClient.getInstance.favoriteWithId(tweet!.id!, complete: { (response, error) -> () in
                if error == nil {
                    //success
                    println("fav success")
                    self.faved = true
                    Utils.toggleFavStatus(true, button: self.favoriteButton)
                } else {
                    println("fav failed \(error)")
                }
            })
        }
        
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !retweeted {
            TwitterClient.getInstance.reTweetWithId(tweet!.id!, complete: { (response, error) -> () in
                if error == nil {
                    //success
                    self.retweeted = true
                    Utils.toggleRetweetStatus(true, button: self.retweetButton)
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
