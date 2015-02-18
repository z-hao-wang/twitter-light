//
//  User.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageURL: String?
    var tagline: String?
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"]  as? String
        profileImageURL = dictionary["profile_image_url"]  as? String
        tagline = dictionary["description"]  as? String
    }
}
