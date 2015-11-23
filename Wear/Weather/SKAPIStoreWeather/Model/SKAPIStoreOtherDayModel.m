//
//  SKAPIStoreOtherDayModel.m
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "SKAPIStoreOtherDayModel.h"

@implementation SKAPIStoreOtherDayModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date": @"date",
             @"week": @"week",
             
             @"windDirection": @"fengxiang",
             @"windLevel": @"fengli",
             @"tempHigh": @"hightemp",
             @"tempLow": @"lowtemp",
             @"condition": @"type",
             };
}

@end
