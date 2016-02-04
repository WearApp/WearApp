//
//  CardDetailTableViewCell.m
//  Wear
//
//  Created by 孙恺 on 15/12/3.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "CardDetailTableViewCell.h"

@interface CardDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation CardDetailTableViewCell

- (void)setLeftText:(NSString *)leftText rightText:(NSString *)rightText {
    [self.leftLabel setText:leftText];
    [self.rightLabel setText:rightText];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
