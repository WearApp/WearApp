//
//  HttpDefine.h
//  HttpRequestManagerDemo
//
//  Created by family on 15/7/7.
//  Copyright (c) 2015年 吴文妹. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WmHttpRequeestDelegate <NSObject>

- (void)refreshDataWithDictionary:(NSDictionary *)dic andFlagString:(NSString *)flagStr;

- (void)connectionFailedWithError:(NSError *)error;

@end

@interface HttpDefine : NSObject

@end
