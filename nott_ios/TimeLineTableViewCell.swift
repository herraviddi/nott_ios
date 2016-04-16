//
//  TimeLineTableViewCell.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 16/04/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {

    var itemIcon = UIImageView()
    var timeLabel = UILabel()
    var titleLabel = UILabel()
    var emojiLevelIcon = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        itemIcon.frame = CGRectMake(contentView.frame.size.width*0.1,contentView.frame.size.height*0.3,contentView.frame.size.height*0.9,contentView.frame.size.height*0.9)
        itemIcon.layer.cornerRadius = (contentView.frame.size.height*0.9)/2
        itemIcon.clipsToBounds = true
        itemIcon.layer.borderColor = Constants.AppColors.graycolor.CGColor
        itemIcon.layer.borderWidth = 0.7
        contentView.addSubview(itemIcon)
        
        timeLabel.frame = CGRectMake(contentView.frame.size.width*0.3, contentView.frame.size.height*0.3, contentView.frame.size.width*0.35, contentView.frame.size.height*0.3)
        timeLabel.textColor = Constants.AppColors.graycolor
        timeLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
        timeLabel.textAlignment = .Left
        contentView.addSubview(timeLabel)
        
        titleLabel.frame = CGRectMake(contentView.frame.size.width*0.30, contentView.frame.size.height*0.7, contentView.frame.size.width*0.35, contentView.frame.size.height*0.4)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        titleLabel.textAlignment = .Left
        contentView.addSubview(titleLabel)
        
        emojiLevelIcon.frame = CGRectMake(contentView.frame.size.width*0.7,contentView.frame.size.height*0.3,contentView.frame.size.height*0.9,contentView.frame.size.height*0.9)
        emojiLevelIcon.layer.cornerRadius = (contentView.frame.size.height*0.9)/2
        emojiLevelIcon.clipsToBounds = true

        contentView.addSubview(emojiLevelIcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
