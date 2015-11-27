//
//  iCocosSettingItem.m
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "iCocosSettingItem.h"

@implementation iCocosSettingItem
+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title type:(iCocosSettingItemType)type
{
    iCocosSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.type = type;
    return item;
}
@end
