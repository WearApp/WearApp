//
//  RequestInfo.h
//  HttpRequestManagerDemo
//
//  Created by family on 15/7/7.
//  Copyright (c) 2015年 吴文妹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDefine.h"

typedef enum HttpRequestMethod {
    HttpRequestMethod_POST,
    HttpRequestMethod_GET,
    HttpRequestMethod_DELETE,
    HttpRequestMethod_PUT,
    HttpRequestMethod_IMAGE,
} HttpRequestMethod;

@interface RequestInfo : NSObject

@property (copy,nonatomic) NSString *urlStr;
@property (assign,nonatomic) HttpRequestMethod method;
@property (strong,nonatomic) NSMutableDictionary *jsonDict;
@property (copy,nonatomic) NSString *flagStr;
@property (strong,nonatomic) NSData *imgData;
@property (assign,nonatomic) id<WmHttpRequeestDelegate>wmDelegate;

@end
