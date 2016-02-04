//
//  TodayEquipmentTableViewCell.m
//  Wear
//
//  Created by 孙恺 on 15/12/7.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "TodayEquipmentTableViewCell.h"

@implementation TodayEquipmentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.stackView setSpacing:0];
    [self.stackView setAlignment:OAStackViewAlignmentTrailing];
    [self.stackView setDistribution:OAStackViewDistributionFillEqually];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
