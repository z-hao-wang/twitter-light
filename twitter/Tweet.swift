//
//  Tweet.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var createdToNow:String?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id"] as? Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    func createdTimeToNow() -> String {
        if createdToNow != nil {
            return createdToNow!
        }
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        var now = NSDate()
        var timeDiff = Int(now.timeIntervalSinceDate(createdAt!))
        let minutes = timeDiff / 60
        var hours = minutes / 60
        var days = hours / 24
        var ret = "0"
        if days > 0 {
            ret = "\(days)d"
        }
        else if hours > 0 {
            ret = "\(hours)h"
        }
        else if minutes > 0 {
            ret = "\(minutes)m"
        }
        createdToNow = ret
        return ret
    }
}
