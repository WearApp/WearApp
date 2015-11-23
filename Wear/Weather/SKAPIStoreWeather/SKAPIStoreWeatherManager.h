//
//  SKAPIStoreWeatherManager.h
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "SKAPIStoreWeatherModel.h"

#import <Foundation/Foundation.h>
#import "SKAPIStoreWeatherModel.h"

@interface SKAPIStoreWeatherManager : NSObject

typedef void (^finishFetch)(SKAPIStoreWeatherModel *model);
typedef void (^failureFetch)(NSError *error);

+ (SKAPIStoreWeatherManager *)sharedInstance;

- (SKAPIStoreWeatherModel *)conditionRequestWithCityid:(NSString *)cityid successBlock:(finishFetch)success failureBlock:(failureFetch)failure;

@end
