//
//  AppDelegate.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        TwitterClient.getInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got the accesss token")
            TwitterClient.getInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.getInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (opreation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("Verify Success user: \(response)")
                var user = User(dictionary: response as NSDictionary)
                println("user: \(user.name!)")
            }, failure: { (opration: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to verify")
            })
            
            TwitterClient.getInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (opreation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("Home timeline Success: \(response)")
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                for tweet in tweets {
                    println("tweet: \(tweet.text!)")
                }
            }, failure: { (opration: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    //println("Failed to home_timeline.json")
                    //var tweet = User(dictionary: response as NSDictionary)
                    
            })
        }) { (error: NSError!) -> Void in
            println("failed to receive accesss token")
        }
        return true
    }

}

