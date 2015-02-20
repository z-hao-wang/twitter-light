//
//  TwitterClient.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

let hwTwitterConsumerKey = "eiu0A3RcRxgQZWx8ZBgIplwQn"
let hwTwitterConsumerSecret = "Ge836ebTc1u6wwX8RHL9FHVKx3CBLN3ryNzCpgeYlI4Hcq1L1e"
let hwTwitterBaseUrl = "https://api.twitter.com"

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var completion: ((user: User?, error: NSError?) -> ())?
    
    class var getInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: NSURL(string: hwTwitterBaseUrl), consumerKey: hwTwitterConsumerKey, consumerSecret: hwTwitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion (complete: (user: User?, error: NSError?) -> ()) {
        // Fetch request token and redirection auth page
        self.requestSerializer.removeAccessToken()
        let callbackURL = NSURL(string: "hwTwitterDemo://oauth")
        self.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: callbackURL, scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            self.completion = complete
        }) { (error: NSError!) -> Void in
            complete(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got the accesss token")
            self.requestSerializer.saveAccessToken(accessToken)
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (opreation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("Verify Success user: \(response)")
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                self.completion!(user: user, error: nil)
            }, failure: { (opration: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    self.completion!(user: nil, error: error)
            })
        }) { (error: NSError!) -> Void in
            println("failed to receive accesss token")
            self.completion!(user: nil, error: error)
        }
    }
    
    func fetchTweetsWithCompletion(complete: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (opreation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            complete(tweets: tweets, error: nil)
        }, failure: { (opration: AFHTTPRequestOperation!, error: NSError!) -> Void in
            complete(tweets: nil, error: error)
        })
    }
    
    func tweetWithText(text: String, complete: (error: NSError!) -> ()) {
        self.POST("1.1/statuses/update.json", parameters: ["status": text], success: { (opreation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            
            complete(error: nil)
            }, failure: { (opration: AFHTTPRequestOperation!, error: NSError!) -> Void in
                complete(error: error)
        })
    }
    /*
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet], error: NSError!) -> ()) {
        
    }*/
}
