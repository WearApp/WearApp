//
//  SKWear.h
//  Wear
//
//  Created by 孙恺 on 15/12/2.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKAPIStoreWeatherModel;

typedef NS_ENUM(NSInteger, EquipmentType) {
    mask = 0,
    umbrella,
    sunscreen
};

@interface SKWear : NSObject

+ (NSInteger)wearIndexWithWeatherModel:(SKAPIStoreWeatherModel *)weatherModel;

+ (NSInteger)wearIndexWithTemperatureHigh:(NSInteger)tempHigh temperatureLow:(NSInteger)tempLow;
+ (NSInteger)equipmentIndexWithConditionText:(NSString *)conditionText equipmentType:(EquipmentType)type;

@end
