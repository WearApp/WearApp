//
//  SKWear.m
//  Wear
//
//  Created by 孙恺 on 15/12/2.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "SKWear.h"
#import "SKAPIStoreWeatherModel.h"

@implementation SKWear

+ (NSInteger)wearIndexWithWeatherModel:(SKAPIStoreWeatherModel *)weatherModel {
    return 1;
}

+ (NSInteger)wearIndexWithTemperatureHigh:(NSInteger)tempHigh temperatureLow:(NSInteger)tempLow {
    if (tempHigh>31&&tempHigh-tempLow<13) {
        return 0;
    }
    
    if (tempHigh>26&&tempHigh-tempLow<15) {
        return 1;
    }
    if (tempHigh>21&&tempHigh-tempLow<17) {
        return 2;
    }
    
    if (tempHigh>16&&tempHigh-tempLow<19) {
        return 3;
    }
    if (tempHigh>11&&tempHigh-tempLow<21) {
        return 4;
    }
    if (tempHigh>6&&tempHigh-tempLow<23) {
        return 5;
    }
    return 6;
}

+ (NSInteger)equipmentIndexWithConditionText:(NSString *)conditionText equipmentType:(EquipmentType)type {
    NSInteger result = 0;
    if ([conditionText isEqualToString:@""]||!conditionText) {
        return 0;
    }
    switch (type) {
        case mask:
            if (conditionText.integerValue>100) {
                result = 1;
            }
            break;
        case umbrella:
            if ([conditionText isEqualToString:@"小雨"]||[conditionText isEqualToString:@"中雨"]||[conditionText isEqualToString:@"大雨"]||[conditionText isEqualToString:@"暴雨"]||[conditionText isEqualToString:@"阵雨"]||[conditionText isEqualToString:@"小到中雨"]||[conditionText isEqualToString:@"中到大雨"]||[conditionText isEqualToString:@"大到暴雨"]) {
                result = 2;
            }
            break;
        case sunscreen:
            if ([conditionText isEqualToString:@"中等"]||[conditionText isEqualToString:@"较强"]||[conditionText isEqualToString:@"强"]) {
                result = 3;
            }
            break;
        default:
            result = 0;
            break;
    }
    return result;
}

@end
