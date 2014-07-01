//
//  CustomCell.m
//  RSSNewsProject
//
//  Created by Admin on 01.07.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,75,60);
    float limgW =  self.imageView.image.size.width;
    if(limgW > 0) {
        self.textLabel.frame = CGRectMake(95,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(95,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
    }
}

@end
