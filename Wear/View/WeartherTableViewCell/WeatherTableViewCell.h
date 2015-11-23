//
//  WeatherTableViewCell.h
//  Wear
//
//  Created by 孙恺 on 15/10/11.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRActivityIndicator.h"
#import <MGSwipeTableCell.h>

@interface WeatherTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIImageView *conditionImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityNameLabelTopConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionImageViewTopConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *temperatureLabelTopConstant;
//@property (weak, nonatomic) IBOutlet YRActivityIndicator *activityIndicator;

- (void)setCityName:(NSString *)cityName conditionNum:(NSInteger)conditionNum temperatureHi:(NSInteger)hi temperatureLow:(NSInteger)low;

- (void)setCity:(NSString *)cityName;
- (void)setTemperatureHi:(NSInteger)hi temperatureLow:(NSInteger)low;
//- (void)setWearSuggestionNumber:(NSInteger)suggestionNumber;
- (void)setConditionNumber:(NSInteger)conditionNumber;

@end
