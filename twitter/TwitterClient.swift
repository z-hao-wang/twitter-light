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
    
    class var getInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: NSURL(string: hwTwitterBaseUrl), consumerKey: hwTwitterConsumerKey, consumerSecret: hwTwitterConsumerSecret)
        }
        return Static.instance
    }
    
    class func loginWithCompletion (complete: (response: AnyObject?, error: NSError!) -> Void) {
        self.getInstance.requestSerializer.removeAccessToken()
        let callbackURL = NSURL(string: "hwTwitterDemo://oauth")
        self.getInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: callbackURL, scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            complete(response: requestToken, error: nil)
        }) { (error: NSError!) -> Void in
            complete(response: nil, error: error)
        }
    }
}
