//
//  WmHttpRequestManager.h
//  HttpRequestManagerDemo
//
//  Created by family on 15/7/7.
//  Copyright (c) 2015年 吴文妹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestInfo.h"

typedef void (^successBlock)(NSDictionary *dic, NSString *flagStr);

typedef void (^failureBlock)(NSError *error);

@interface WmHttpRequestManager : NSObject

///创建请求manager
+ (WmHttpRequestManager *)shareManager;

///发起请求
- (void)startAsyncHttpRequestWithRequestInfo:(RequestInfo *)requestInfo successBlock:(successBlock)success failureBlock:(failureBlock)failure;

///页面dealloc的时候，取消联网
- (void)cancelRequest;

@end
