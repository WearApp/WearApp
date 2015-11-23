//
//  SKAPIStoreWeatherModel.m
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "SKAPIStoreWeatherModel.h"

@implementation SKAPIStoreWeatherModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
 return @{
     @"errorMessage": @"errMsg",
     @"errorNumber": @"errNum",
     
     @"city": @"retData.city",
     @"cityid": @"retData.cityid",
     
     @"today": @"retData.today",
     @"forecast": @"retData.forecast",
     @"history": @"retData.history",
     };
}

@end
