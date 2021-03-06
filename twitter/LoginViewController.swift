//
//  LoginViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.getInstance.loginWithCompletion { (user, error) -> Void in
            if let err = error {
                println("failed")
            } else {
                println("success \(user!.name!)");
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
