//
//  ForecastCardView.m
//  Wear
//
//  Created by 孙恺 on 15/12/5.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "ForecastCardView.h"

@implementation ForecastCardView

// Convenience Method
+ (instancetype)viewFromNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}

- (void)awakeFromNib {
    // 视图内容布局
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
