//
//  FirstRunTableViewCell.m
//  Wear
//
//  Created by 孙恺 on 15/11/27.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "FirstRunTableViewCell.h"

@interface FirstRunTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@end

@implementation FirstRunTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setLeftText:(NSString *)leftText rightImage:(UIImage *)image {
    [self.leftLabel setText:leftText];
    [self.rightImageView setImage:image];
    
    [self.rightLabel setHidden:YES];
    [self.leftImageView setHidden:YES];
    
    [self.leftLabel setHidden:NO];
    [self.rightImageView setHidden:NO];
    
}

- (void)setRightText:(NSString *)rightText leftImage:(UIImage *)image {
    [self.rightLabel setText:rightText];
    [self.leftImageView setImage:image];
    
    [self.rightLabel setHidden:NO];
    [self.leftImageView setHidden:NO];
    
    [self.leftLabel setHidden:YES];
    [self.rightImageView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
