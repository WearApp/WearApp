//
//  SKAPIStoreIndexModel.m
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "SKAPIStoreIndexModel.h"

@implementation SKAPIStoreIndexModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code": @"code",
             @"name": @"name",
             @"level": @"index",
             @"detailText": @"details",
             @"otherName": @"otherName"
             };
}

@end
