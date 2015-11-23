//
//  HeaderView.m
//  Example
//
//  Created by Marek Serafin on 26/09/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowTemperatureLabel;

@end

@implementation HeaderView

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

- (void)setCityName:(NSString *)cityName temperarute:(NSString *)temperature tempLow:(NSString *)tempLow tempHigh:(NSString *)tempHigh {
    [self.cityNameLabel setText:cityName];
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%@℃", temperature]];
    [self.highLowTemperatureLabel setText:[NSString stringWithFormat:@"%@℃ - %@℃", tempLow, tempHigh]];
}

@end
