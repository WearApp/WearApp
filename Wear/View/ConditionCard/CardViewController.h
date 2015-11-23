//
//  CardViewController.h
//  Wear
//
//  Created by 孙恺 on 15/11/9.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKAPIStoreWeatherModel.h"

//@class STPopupNavigationBar;

//@protocol STPopupNavigationTouchEventDelegate <NSObject>
//
//- (void)popupNavigationBar:(STPopupNavigationBar *)navigationBar touchDidMoveWithOffset:(CGFloat)offset;
//- (void)popupNavigationBar:(STPopupNavigationBar *)navigationBar touchDidEndWithOffset:(CGFloat)offset;
//
//@end

@interface CardViewController : UIViewController

//@property (nonatomic, weak) id<STPopupNavigationTouchEventDelegate> touchEventDelegate;

@property (nonatomic, strong) SKAPIStoreWeatherModel *weather;
@property (nonatomic, assign) BOOL draggable; // Default: YES

@end
