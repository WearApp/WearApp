//
//  TodayCardView.h
//  Wear
//
//  Created by 孙恺 on 15/12/5.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayCardView : UIView

+ (instancetype)viewFromNIB;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wearImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
