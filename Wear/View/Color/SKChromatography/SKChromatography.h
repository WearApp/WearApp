//
//  SKChromatography.h
//  Wear
//
//  Created by 孙恺 on 15/7/27.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKChromatography : NSObject

+ (instancetype)shareManager;

- (UIColor *)colorWithNumString:(NSString *)number;

+ (UIColor *)temperatureColorWithHue:(CGFloat)hue;

@end
