//
//  HeaderView.m
//  Example
//
//  Created by Marek Serafin on 26/09/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "HeaderView.h"
#import "SKChromatography.h"
#import "SKAPIStoreWeatherModel.h"
#import "SKWear.h"
#import "OAStackView.h"

@interface HeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewWidthConstraints;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowTemperatureLabel;

@property (weak, nonatomic) IBOutlet OAStackView *stackView;
@property (weak, nonatomic) IBOutlet UIImageView *wearIconImageView;
//@property (weak, nonatomic) IBOutlet UILabel *wearSuggestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;


@end

@implementation HeaderView

- (NSString *)cityName {
    return self.cityNameLabel.text;
}

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

- (void)setWeatherModel:(SKAPIStoreWeatherModel *)weatherModel {
    self.weather = [[SKAPIStoreWeatherModel alloc] init];
    self.weather = weatherModel;
    
    NSLog(@"传参成功");
    
    NSInteger temperatureHi = [weatherModel.today.tempHigh substringWithRange:NSMakeRange(0, weatherModel.today.tempHigh.length-1)].integerValue;
    NSInteger temperatureLow = [weatherModel.today.tempLow substringWithRange:NSMakeRange(0, weatherModel.today.tempLow.length-1)].integerValue;
    [self.cityNameLabel setText:weatherModel.city];
    [self.temperatureLabel setText:weatherModel.today.currentTemp];
    [self.highLowTemperatureLabel setText:[NSString stringWithFormat:@"%@ - %@", weatherModel.today.tempLow, weatherModel.today.tempHigh]];
    [self.wearIconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"wear%li",[SKWear wearIndexWithTemperatureHigh:temperatureHi temperatureLow:temperatureLow]]]];
    [self.conditionLabel setText:weatherModel.today.condition];
//    self.wearSuggestionLabel
    
    
    [self setBackgroundColor:[SKChromatography temperatureColorWithHue:340-([self.temperatureLabel.text substringWithRange:NSMakeRange(0, self.temperatureLabel.text.length-1)].floatValue+10)*8.8 alpha:0.7f]];
    
    
    UIImageView *icon1 = [SKWear equipmentIndexWithConditionText:@"101" equipmentType:mask]?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"equipment1"]]:nil;
    UIImageView *icon2 = [SKWear equipmentIndexWithConditionText:@"中雨" equipmentType:umbrella]?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"equipment2"]]:nil;
    UIImageView *icon3 = [SKWear equipmentIndexWithConditionText:@"强" equipmentType:sunscreen]?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"equipment3"]]:nil;
    
    [self.stackView setSpacing:0];
    [self.stackView setAlignment:OAStackViewAlignmentTrailing];
    [self.stackView setDistribution:OAStackViewDistributionFillEqually];
    
    [icon1 setFrame:CGRectMake(0, 0, 18, 18)];
    [icon2 setFrame:CGRectMake(0, 0, 18, 18)];
    [icon3 setFrame:CGRectMake(0, 0, 18, 18)];
    
    [icon1 setContentMode:UIViewContentModeScaleAspectFit];
    [icon2 setContentMode:UIViewContentModeScaleAspectFit];
    [icon3 setContentMode:UIViewContentModeScaleAspectFit];
    
    for (UIView *view in self.stackView.subviews) {
        [self.stackView removeArrangedSubview:view];
    }
    
    NSInteger iconCount = 0;
    
    if (icon1) {
        [self.stackView addArrangedSubview:icon1];
        iconCount++;
    }
    if (icon2) {
        [self.stackView addArrangedSubview:icon2];
        iconCount++;
    }
    if (icon3) {
        [self.stackView addArrangedSubview:icon3];
        iconCount++;
    }
    NSLog(@"%li",iconCount);
    [self.stackViewWidthConstraints setConstant:iconCount*18+(iconCount-1)*16];
}

- (void)setCityName:(NSString *)cityName temperarute:(NSString *)temperature tempLow:(NSString *)tempLow tempHigh:(NSString *)tempHigh {
    [self.cityNameLabel setText:cityName];
    [self.temperatureLabel setText:[NSString stringWithFormat:@"%@", temperature]];
    [self.highLowTemperatureLabel setText:[NSString stringWithFormat:@"%@ - %@", tempLow, tempHigh]];
    if (![cityName isEqualToString:@"--"]) {
        [self setBackgroundColor:[SKChromatography temperatureColorWithHue:340-([temperature substringWithRange:NSMakeRange(0, temperature.length-1)].floatValue+10)*8.8 alpha:0.7f]];
    } else {
        [self setBackgroundColor:[SKChromatography temperatureColorWithHue:270-20*0.60*8 alpha:0.7f]];
    }
    
}

- (void)setCityLabelTextSize {
    self.cityNameLabel.adjustsFontSizeToFitWidth = YES;
    self.temperatureLabel.adjustsFontSizeToFitWidth = YES;
}

@end
