//
//  User.swift
//  twitter
//
//  Created by Hao Wang on 2/17/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

var _currentUser: User? = nil
var currentUserKey = "_currentUser"
let userDidLoginNotification = "UserDidLoginNotification"
let userDidLogoutNotification = "UserDidLogoutNotification"
class User: NSObject {
    
    var id: Int?
    var name: String?
    var screenName: String?
    var profileImageURL: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"]  as? String
        profileImageURL = dictionary["profile_image_url"]  as? String
        tagline = dictionary["description"]  as? String
        id = dictionary["id"] as? Int
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.getInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                //try get from NSUserDefaults
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary
                    _currentUser = User(dictionary: dictionary!)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            // Store it if set
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(_currentUser!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: "_currentUser")
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "_currentUser")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func getAttr(attr: String) -> Int? {
        if let attrVal = dictionary[attr] as? Int {
            return attrVal
        }
        return nil
    }
    
    func getAttr(attr: String) -> String? {
        if let attrVal = dictionary[attr] as? String {
            return attrVal
        }
        return nil
    }
}
