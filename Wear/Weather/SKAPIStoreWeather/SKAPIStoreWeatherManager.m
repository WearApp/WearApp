//
//  SKAPIStoreWeatherManager.m
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "WmHttpRequestManager.h"
#import "SKAPIStoreWeatherManager.h"

@interface SKAPIStoreWeatherManager ()<WmHttpRequeestDelegate>

@end

@implementation SKAPIStoreWeatherManager

#pragma mark - Request Callback

- (void)refreshDataWithDictionary:(NSDictionary *)dic andFlagString:(NSString *)flagStr {
    
//    NSLog(@"%@",dic);
}

- (void)connectionFailedWithError:(NSError *)error {
//    NSLog(@"%@",error.description);
}

#pragma mark - Request

- (SKAPIStoreWeatherModel *)conditionRequestWithCityid:(NSString *)cityid successBlock:(finishFetch)success failureBlock:(failureFetch)failure {
    RequestInfo *info = [[RequestInfo alloc] init];
    info.jsonDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObject:cityid forKey:@"cityid"]];
    info.method = HttpRequestMethod_GET;
    info.urlStr = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    info.wmDelegate = self;
    
    [[WmHttpRequestManager shareManager] startAsyncHttpRequestWithRequestInfo:info successBlock:^(NSDictionary *dic, NSString *flagStr) {
        NSError *error;
        SKAPIStoreWeatherModel *model = [MTLJSONAdapter modelOfClass:SKAPIStoreWeatherModel.class fromJSONDictionary:dic error:&error];
        if (!error) {
            success(model);
        }
    } failureBlock:^(NSError *error) {
        failure(error);
//        NSLog(@"block:%@",error.description);
    }];
    return nil;
}
    
#pragma mark - Init

+ (SKAPIStoreWeatherManager *)sharedInstance {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
