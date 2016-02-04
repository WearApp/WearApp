//
//  ForecastTableViewCell.h
//  Wear
//
//  Created by 孙恺 on 15/12/6.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *wearIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;

@end
