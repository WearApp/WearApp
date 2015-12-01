//
//  HeaderView.h
//  Example
//
//  Created by Marek Serafin on 26/09/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

+ (instancetype)instantiateFromNib;

- (void)setCityName:(NSString *)cityName temperarute:(NSString *)temperature tempLow:(NSString *)tempLow tempHigh:(NSString *)tempHigh;

- (void)setCityLabelTextSize;

@end
