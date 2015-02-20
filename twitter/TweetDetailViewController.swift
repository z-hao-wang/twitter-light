//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/19/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweet:Tweet?
    
    @IBOutlet weak var tweetText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweetUnwrapped = tweet {
            tweetText.text = tweetUnwrapped.text
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeView() {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
   
    @IBAction func onReply(sender: AnyObject) {
        self.performSegueWithIdentifier("composeSegue2", sender: self)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.getInstance.reTweetWithId(tweet!.id!, complete: { (error) -> () in
            if error == nil {
                //success
                self.closeView()
            } else {
                println("retweet failed")
            }
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.getInstance.favoriteWithId(tweet!.id!, complete: { (error) -> () in
            if error == nil {
                //success
                println("fav success")
            } else {
                println("fav failed \(error)")
            }
        })
    }
    
    @IBAction func onBack(sender: AnyObject) {
        closeView()
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        self.performSegueWithIdentifier("composeSegue2", sender: self)
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
