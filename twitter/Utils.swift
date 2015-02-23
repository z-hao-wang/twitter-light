//
//  Utils.swift
//  twitter
//
//  Created by Hao Wang on 2/22/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class Utils: NSObject {
    class func toggleRetweetStatus(on: Bool, button: UIButton) {
        let img = UIImage(named: on ? "retweet_on" : "retweet") as UIImage?
        button.setImage(img, forState: .Normal)
    }
    
    class func toggleFavStatus(on: Bool, button: UIButton) {
        let img = UIImage(named: on ? "favorite_on" : "favorite") as UIImage?
        button.setImage(img, forState: .Normal)
    }
}
