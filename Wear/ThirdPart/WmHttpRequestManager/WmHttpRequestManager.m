//
//  WmHttpRequestManager.m
//  HttpRequestManagerDemo
//
//  Created by family on 15/7/7.
//  Copyright (c) 2015年 吴文妹. All rights reserved.
//

#import "WmHttpRequestManager.h"
#import "AFNetworking.h"

@interface WmHttpRequestManager() {
    AFHTTPRequestOperationManager *_manager;
}

@property (nonatomic,strong) AFHTTPRequestOperation *httpOperation;

@end

@implementation WmHttpRequestManager

#pragma mark - 对外公开接口
+ (WmHttpRequestManager *)shareManager {
    static WmHttpRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (manager == nil) {
            manager = [[WmHttpRequestManager alloc]init];
        }
    });
    return manager;
}

- (void)startAsyncHttpRequestWithRequestInfo:(RequestInfo *)requestInfo successBlock:(successBlock)success failureBlock:(failureBlock)failure{
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    if (requestInfo.jsonDict) {
        jsonDict = requestInfo.jsonDict;
    }
    //添加请求头信息
    [self createHttpHeader];
    
    //不同的请求方式
    if (requestInfo.method == HttpRequestMethod_GET) {
        self.httpOperation = [_manager GET:requestInfo.urlStr parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //请求成功，转换成json字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            [requestInfo.wmDelegate refreshDataWithDictionary:dic andFlagString:requestInfo.flagStr];
            success(dic, requestInfo.flagStr);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //请求失败
            [requestInfo.wmDelegate connectionFailedWithError:error];
            failure(error);
        }];
        return;
    }
    if (requestInfo.method == HttpRequestMethod_POST) {
        self.httpOperation = [_manager POST:requestInfo.urlStr parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            [requestInfo.wmDelegate refreshDataWithDictionary:dic andFlagString:requestInfo.flagStr];
            success(dic, requestInfo.flagStr);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [requestInfo.wmDelegate connectionFailedWithError:error];
            failure(error);
        }];
        return;
    }
    if (requestInfo.method == HttpRequestMethod_PUT) {
        self.httpOperation = [_manager PUT:requestInfo.urlStr parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
             [requestInfo.wmDelegate refreshDataWithDictionary:dic andFlagString:requestInfo.flagStr];
            success(dic, requestInfo.flagStr);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [requestInfo.wmDelegate connectionFailedWithError:error];
            failure(error);
        }];
        return;
    }
    if (requestInfo.method == HttpRequestMethod_DELETE) {
        self.httpOperation = [_manager DELETE:requestInfo.urlStr parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            [requestInfo.wmDelegate refreshDataWithDictionary:dic andFlagString:requestInfo.flagStr];
            success(dic, requestInfo.flagStr);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [requestInfo.wmDelegate connectionFailedWithError:error];
            failure(error);
        }];
        return;
    }
    if (requestInfo.method == HttpRequestMethod_IMAGE) {
        self.httpOperation = [_manager POST:requestInfo.urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:requestInfo.imgData name:@"file" fileName:@"icon.jpg" mimeType:@"image/*"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
             [requestInfo.wmDelegate refreshDataWithDictionary:dic andFlagString:requestInfo.flagStr];
            success(dic, requestInfo.flagStr);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [requestInfo.wmDelegate connectionFailedWithError:error];
            failure(error);
        }];
    }
}

- (void)cancelRequest {
    [self.httpOperation cancel];
}

- (id)init {
    if (self = [super init]) {
        _manager = [[AFHTTPRequestOperationManager alloc]init];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        _manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    return self;
}

#pragma mark - 添加请求体信息，可自定义
- (void)createHttpHeader {
    [_manager.requestSerializer setValue:@"fb9e5e49354669b62934dd0ef59275ac" forHTTPHeaderField:@"apikey"];
}

@end
