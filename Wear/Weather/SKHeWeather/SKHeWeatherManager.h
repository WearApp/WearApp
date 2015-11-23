//
//  SKHeWeatherManager.h
//  Wear
//
//  Created by 孙恺 on 15/7/28.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLocation.h"
#import "SKHeWeatherCondition.h"

@interface SKHeWeatherManager : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) SKLocation *location;
@property (nonatomic, strong) SKHeWeatherCondition *weatherCondition;

- (void)refreshConditionWithCityName:(NSString *)cityName;
- (void)refreshConditionWithCurrentLocation;

@end
