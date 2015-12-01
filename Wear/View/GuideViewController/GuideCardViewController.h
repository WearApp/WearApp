//
//  GuideCardViewController.h
//  Wear
//
//  Created by 孙恺 on 15/11/28.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideCardViewController : UIViewController

@property (nonatomic, assign) BOOL draggable; // Default: YES
- (void)setBigText:(NSString *)bigtext description:(NSString *)descriptionText;

@end
