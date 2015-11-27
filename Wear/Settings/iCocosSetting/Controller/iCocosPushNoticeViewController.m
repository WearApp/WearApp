//
//  iCocosPushNoticeViewController.m
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "iCocosPushNoticeViewController.h"

@interface iCocosPushNoticeViewController ()

@end

@implementation iCocosPushNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"推送和提醒";
    
    // 1.1
    iCocosSettingItem *item1 = [iCocosSettingItem itemWithIcon:nil title:@"开奖号码推送" type:iCocosSettingItemTypeArrow];
    
    // 1.2
    iCocosSettingItem *item2 = [iCocosSettingItem itemWithIcon:nil title:@"中奖动画" type:iCocosSettingItemTypeArrow];
    
    // 1.3
    iCocosSettingItem *item3 = [iCocosSettingItem itemWithIcon:nil title:@"比分直播提醒" type:iCocosSettingItemTypeArrow];
    
    // 1.4
    iCocosSettingItem *item4 = [iCocosSettingItem itemWithIcon:nil title:@"购彩定时提醒" type:iCocosSettingItemTypeArrow];
    
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[item1, item2, item3, item4];
    [_allGroups addObject:group];
}

@end
