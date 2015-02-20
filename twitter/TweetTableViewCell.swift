//
//  TweetTableViewCell.swift
//  twitter
//
//  Created by Hao Wang on 2/19/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var timeStamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
