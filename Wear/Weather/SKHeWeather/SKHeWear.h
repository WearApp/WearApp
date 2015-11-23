//
//  SKHeWear.h
//  Wear
//
//  Created by 孙恺 on 15/7/30.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKHeWeatherCondition.h"

@interface SKHeWear : NSObject

@property (strong, nonatomic) NSDictionary *wear;
/* 
 * @"sunglasses",   墨镜
 * @"suncream",     防晒霜
 * @"sunumbrella",  太阳伞
 * @"umbrella",     雨伞
 * @"coat",         外套
 * @"undercoat",    里衣
 * @"shoes"         鞋子
 */

- (instancetype)initWithCurrentWeatherCondition:(SKHeWeatherCondition *)weatherCondition;
- (instancetype)initWithSingleDayWeatherCondition:(NSDictionary *)weatherCondition;

@end
