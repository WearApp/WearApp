//
//  WeatherTableViewCell.m
//  Wear
//
//  Created by 孙恺 on 15/10/11.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "SKChromatography.h"

@implementation WeatherTableViewCell

- (void)awakeFromNib {
//    [self activityIndicator];
    // Initialization code
}

//- (void)activityIndicatorSet {
//    _activityIndicator.minItemSize = (CGSize){5, 5};
//    _activityIndicator.maxItemSize = (CGSize){20, 20};
//    _activityIndicator.maxItems = 6;
//    
//    _activityIndicator.maxSpeed = 1.6;
//    
//    _activityIndicator.cycleDuration = 2;
//    
//    _activityIndicator.radius = 30;
//    
//    _activityIndicator.itemImage = nil;
//    _activityIndicator.itemColor = [UIColor whiteColor];
//    
//    _activityIndicator.firstBezierControlPoint = (CGPoint){0.89, 0};
//    _activityIndicator.secondBezierControlPoint = (CGPoint){0.12, 1};
//    
//    _activityIndicator.backgroundColor = [UIColor clearColor];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCityName:(NSString *)cityName conditionNum:(NSInteger)conditionNum temperatureHi:(NSInteger)hi temperatureLow:(NSInteger)low {
//    NSLog(@"%f",270-(((float)(hi+low))/2+20)*0.60*8);
    [self setBackgroundColor:[SKChromatography temperatureColorWithHue:270-(((float)(hi+low))/2+20)*0.60*8]];
//    [self setBackgroundColor:[UIColor colorWithHue:80.0f/255.0f saturation:140.0f/255.0f brightness:160.0f/255.0f alpha:1]];
//    [self setBackgroundColor:[UIColor colorWithHue:204.0f/359.0f saturation:42.0f/100.0f brightness:66.0f/100.0f alpha:1]];
    [self.cityLabel setText:cityName];
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%li℃-%li℃", low, hi]];
    [self.conditionImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"condition%li",(long)conditionNum]]];
    
}

- (void)setCity:(NSString *)cityName {
    [self.cityLabel setText:cityName];
}

- (void)setTemperatureHi:(NSInteger)hi temperatureLow:(NSInteger)low {
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%li℃-%li℃", (long)low, (long)hi]];
}

- (void)setConditionNumber:(NSInteger)conditionNumber {
    [self.conditionImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"condition%li",(long)conditionNumber]]];
}


@end
