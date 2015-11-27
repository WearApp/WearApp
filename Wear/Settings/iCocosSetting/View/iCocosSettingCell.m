//
//  iCocosSettingself.m
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "iCocosSettingCell.h"
#import "iCocosSettingItem.h"

@interface iCocosSettingCell()
{
    UIImageView *_arrow;
    UISwitch *_switch;
}
@end

@implementation iCocosSettingCell

+ (id)settingCellWithTableView:(UITableView *)tableView
{
    // 0.用static修饰的局部变量，只会初始化一次
    static NSString *ID = @"Cell";
    
    // 1.拿到一个标识先去缓存池中查找对应的Cell
    iCocosSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 2.如果缓存池中没有，才需要传入一个标识创建新的Cell
    if (cell == nil) {
        cell = [[iCocosSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setItem:(iCocosSettingItem *)item
{
    _item = item;
    
    // 设置数据
    self.imageView.image = [UIImage imageNamed:item.icon];
    self.textLabel.text = item.title;
    
    if (item.type == iCocosSettingItemTypeArrow) {
        
        if (_arrow == nil) {
            _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
        }
        
        // 右边显示箭头
        self.accessoryView = _arrow;
        // 用默认的选中样式
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    } else if (item.type == iCocosSettingItemTypeSwitch) {
        
        if (_switch == nil) {
            _switch = [[UISwitch alloc] init];
        }
        
        // 右边显示开关
        self.accessoryView = _switch;
        // 禁止选中
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        
        // 什么也没有，清空右边显示的view
        self.accessoryView = nil;
        // 用默认的选中样式
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
}
@end
