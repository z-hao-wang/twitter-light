//
//  ProfileViewController.swift
//  twitter
//
//  Created by Hao Wang on 2/26/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var data: User?
    @IBOutlet weak var userNameLabel: UILabel!
    var delegate: swipeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSwipe(sender: UIPanGestureRecognizer) {
        delegate?.processSwipe(sender)
    }
    
    func update(newUser: User? = nil) {
        if newUser != nil {
            data = newUser
        }
        //update the view
        if data != nil {
            userNameLabel.text = data!.name!
        }
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
