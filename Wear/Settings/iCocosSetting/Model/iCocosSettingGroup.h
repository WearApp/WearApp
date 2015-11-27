//
//  iCocosSettingGroup.h
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iCocosSettingGroup : NSObject
@property (nonatomic, copy) NSString *header; // 头部标题
@property (nonatomic, copy) NSString *footer; // 尾部标题
@property (nonatomic, strong) NSArray *items; // 中间的条目


@end
