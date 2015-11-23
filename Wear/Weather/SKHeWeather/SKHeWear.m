//
//  SKHeWear.m
//  Wear
//
//  Created by 孙恺 on 15/7/30.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import "SKHeWear.h"

@implementation SKHeWear

@synthesize wear;

- (instancetype)initWithCurrentWeatherCondition:(SKHeWeatherCondition *)weatherCondition {
    self = [super init];
    if (self) {
        NSArray *value = [NSArray arrayWithObjects:
                          [self sunglassesIndexWithCondition:weatherCondition.now_condition_chn],
                          [self suncreamIndexWithCondition:weatherCondition.now_condition_chn uv_str:weatherCondition.suggestion_uv_str],
                          [self sunumbrellaIndexWithCondition:weatherCondition.now_condition_chn],
                          [self umbrellaIndex],
                          [self coatIndex],
                          [self undercoatIndex],
                          [self shoesIndex],
                          nil];
        NSArray *key = [NSArray arrayWithObjects:
                        @"sunglasses", @"suncream",
                        @"sunumbrella", @"umbrella",
                        @"coat", @"undercoat", @"shoes", nil];
        self.wear = [[NSDictionary alloc] initWithObjects:value forKeys:key];
    }
    return self;
}
- (instancetype)initWithSingleDayWeatherCondition:(NSDictionary *)weatherCondition {
    self = [super init];
    if (self) {
        NSArray *value = [NSArray arrayWithObjects:
                          [self sunglassesIndexWithCondition:weatherCondition[@"cond"][@"txt_d"]],
                          @1, //[self suncreamIndex],
                          [self sunumbrellaIndexWithCondition:weatherCondition[@"cond"][@"txt_d"]],
                          [self umbrellaIndex],
                          [self coatIndex],
                          [self undercoatIndex],
                          [self shoesIndex],
                          nil];
        NSArray *key = [NSArray arrayWithObjects:
                        @"sunglasses", @"suncream",
                        @"sunumbrella", @"umbrella",
                        @"coat", @"undercoat", @"shoes", nil];
        self.wear = [[NSDictionary alloc] initWithObjects:value forKeys:key];
    }
    return self;
}

- (NSNumber *)sunglassesIndexWithCondition:(NSString *)condition_str {
    if ([condition_str isEqualToString:@"晴"]) {
        return @1;
    } else {
        return @0;
    }
}

- (NSNumber *)suncreamIndexWithCondition:(NSString *)condition_str uv_str:(NSString *)uv {
    
    
    NSNumber *num = [[NSNumber alloc] initWithInt:0];
    
    return num;
}

- (NSNumber *)sunumbrellaIndexWithCondition:(NSString *)condition_str {
    NSNumber *num = [[NSNumber alloc] initWithInt:0];
    
    return num;
}

- (NSNumber *)umbrellaIndex {
    NSNumber *num = [[NSNumber alloc] initWithInt:0];
    
    return num;
}

- (NSNumber *)coatIndex {
    NSNumber *num = [[NSNumber alloc] initWithInt:0];
    
    return num;
}

- (NSNumber *)undercoatIndex {
    NSNumber *num = [[NSNumber alloc] initWithInt:0];
    
    return num;
}

- (NSNumber *)shoesIndex {
    NSNumber *num = [[NSNumber alloc] initWithInt:0];
    
    return num;
}

@end
