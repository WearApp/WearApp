//
//  WeatherTableViewCell.m
//  Wear
//
//  Created by 孙恺 on 15/10/11.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "SKChromatography.h"
#import "SKAPIStoreWeatherModel.h"
#import "SKWear.h"

@implementation WeatherTableViewCell

- (void)awakeFromNib {
    
    [self.wearIconImageView setContentMode:UIViewContentModeScaleAspectFit];
    
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

- (void)setWeatherModel:(SKAPIStoreWeatherModel *)weatherModel {
    NSInteger temperatureLow = [weatherModel.today.tempLow substringWithRange:NSMakeRange(0, weatherModel.today.tempLow.length-1)].integerValue;
    NSInteger temperatuteHi = [weatherModel.today.tempHigh substringWithRange:NSMakeRange(0, weatherModel.today.tempHigh.length-1)].integerValue;
    
    [self setBackgroundColor:[SKChromatography temperatureColorWithHue:340-([weatherModel.today.currentTemp substringWithRange:NSMakeRange(0, weatherModel.today.currentTemp.length-1)].floatValue+10)*8.8 alpha:0.7f]];
    [self.cityLabel setText:weatherModel.city];
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%@ - %@ %@", weatherModel.today.tempLow, weatherModel.today.tempHigh, weatherModel.today.condition]];
    [self.wearIconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"wear%li",[SKWear wearIndexWithTemperatureHigh:temperatuteHi temperatureLow:temperatureLow]]]];
}

- (void)setCityName:(NSString *)cityName conditionNum:(NSInteger)conditionNum temperatureHi:(NSInteger)hi temperatureLow:(NSInteger)low {
    [self setBackgroundColor:[SKChromatography temperatureColorWithHue:340-((float)(hi+low)/2+10)*8.8 alpha:0.7f]];
    [self.cityLabel setText:cityName];
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%li℃-%li℃", low, hi]];
//    [self.conditionImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"condition%li",(long)conditionNum]]];
    
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
