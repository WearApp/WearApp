//
//  FirstRunTableViewCell.h
//  Wear
//
//  Created by 孙恺 on 15/11/27.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@interface FirstRunTableViewCell : MGSwipeTableCell

- (void)setLeftText:(NSString *)leftText rightImage:(UIImage *)image;
- (void)setRightText:(NSString *)rightText leftImage:(UIImage *)image;

@end
