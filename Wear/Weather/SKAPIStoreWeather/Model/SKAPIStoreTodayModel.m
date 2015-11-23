//
//  SKAPIStoreTodayModel.m
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "SKAPIStoreTodayModel.h"

@implementation SKAPIStoreTodayModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date": @"date",
             @"week": @"week",
             
             @"currentTemp": @"curTemp",
             @"aqi": @"aqi",
             @"windDirection": @"fengxiang",
             @"windLevel": @"fengli",
             @"tempHigh": @"hightemp",
             @"tempLow": @"lowtemp",
             @"condition": @"type",
             @"index": @"index"
             };
}

@end
