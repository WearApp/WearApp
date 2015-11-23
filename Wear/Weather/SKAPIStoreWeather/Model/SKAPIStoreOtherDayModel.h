//
//  SKAPIStoreOtherDayModel.h
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SKAPIStoreOtherDayModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *week;

@property (nonatomic, copy) NSString *windDirection;
@property (nonatomic, copy) NSString *windLevel;
@property (nonatomic, copy) NSString *tempHigh;
@property (nonatomic, copy) NSString *tempLow;
@property (nonatomic, copy) NSString *condition;

@end
