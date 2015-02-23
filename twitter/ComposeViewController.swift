//
//  ComposeViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/19/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {


    @IBOutlet weak var textField: UITextView!
    var replyTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if let reply = replyTweet {
            println("Reply Tweet \(reply.id!)")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        replyTweet = nil //clear this value for next compose
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorWithText(message: String) {
        println("Error: \(message)")
    }
    
    func completeTweet(response: AnyObject!, error: NSError!) -> () {
        if error == nil {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.showErrorWithText("Tweet Success")
                // push tweet object into model
                if self.replyTweet != nil {
                   //broadcast an event for new tweet
                    
                } else {
                    
                }
                var newTweet: Tweet = Tweet(dictionary: response as NSDictionary)
                var userInfo: Dictionary<String, Tweet> = ["tweet": newTweet]
                NSNotificationCenter.defaultCenter().postNotificationName(newTweetNotification, object: nil, userInfo: userInfo)
            })
        } else {
            self.showErrorWithText("Tweet Failed")
        }
    }

    @IBAction func didTweet(sender: AnyObject) {
        if !textField.text.isEmpty {
            if let reply = replyTweet {
                TwitterClient.getInstance.replyTweet(textField.text, id: reply.id!, complete: completeTweet)
            } else {
                TwitterClient.getInstance.tweetWithText(textField.text, complete: completeTweet)
            }
        } else {
            self.showErrorWithText("Tweet is Empty")
        }
    }
    
    @IBAction func didClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
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
