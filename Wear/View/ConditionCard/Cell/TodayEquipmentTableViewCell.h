//
//  TodayEquipmentTableViewCell.h
//  Wear
//
//  Created by 孙恺 on 15/12/7.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAStackView.h"

@interface TodayEquipmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet OAStackView *stackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewWidthConstraints;

@end
