//
//  SKAPIStoreWeatherModel.h
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "SKAPIStoreTodayModel.h"
#import "SKAPIStoreOtherDayModel.h"

@interface SKAPIStoreWeatherModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSDate *updateTime;

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, strong) NSNumber *errorNumber;

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cityid;

@property (nonatomic, strong) SKAPIStoreTodayModel *today;
@property (nonatomic, strong) NSArray<SKAPIStoreOtherDayModel *> *forecast;
@property (nonatomic, strong) NSArray<SKAPIStoreOtherDayModel *> *history;

@end
