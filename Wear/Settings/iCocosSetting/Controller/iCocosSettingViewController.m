//
//  iCocosSettingViewController.m
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "EggsViewController.h"
#import "iCocosSettingViewController.h"
#import "iCocosPushNoticeViewController.h"
#import "UIScrollView+VORefresh.h"

#import "GuideViewController.h"

@interface iCocosSettingViewController ()
@end

@implementation iCocosSettingViewController

#pragma mark - Back

- (void)setupSettingRefreshing {
    [self.tableView addTopRefreshWithTarget:self action:@selector(topRefreshing)];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"下拉返回"];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"下拉返回"];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:@"释放返回"];
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:@"正在返回"];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str1.length)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, str2.length)];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(0, str3.length)];
    [str4 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, str4.length)];
    self.tableView.topRefresh.refreshTexts = @[str1, str2, str3, str4];
    
    [self.tableView addBottomRefreshWithTarget:self action:@selector(bottomRefreshing)];
    NSMutableAttributedString *str5 = [[NSMutableAttributedString alloc] initWithString:@"呵呵"];
    NSMutableAttributedString *str6 = [[NSMutableAttributedString alloc] initWithString:@"呵呵"];
    NSMutableAttributedString *str7 = [[NSMutableAttributedString alloc] initWithString:@"松手"];
    NSMutableAttributedString *str8 = [[NSMutableAttributedString alloc] initWithString:@"哈哈"];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str5.length)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, str6.length)];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(0, str7.length)];
    [str4 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, str8.length)];
    self.tableView.bottomRefresh.refreshTexts = @[str5, str6, str7, str8];
}




#pragma mark - Refreshing

- (void)topRefreshing{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView.topRefresh endRefreshing];
}

- (void)bottomRefreshing{
    NSLog(@"setting");
    
    EggsViewController *eggVC = [[EggsViewController alloc] init];
    //    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
//    UITabBarController *tabbarVC = [[UITabBarController alloc] init];
//    [tabbarVC addChildViewController:settingVC];
    
    [self presentViewController:eggVC animated:YES completion:nil];
    [self.tableView.bottomRefresh endRefreshing];
}




#pragma mark - Lifeccyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 1.第0组：3个
    [self add0SectionItems];
    
    // 2.第1组：6个
    [self add1SectionItems];
    
    [self setupSettingRefreshing];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    // 1.1.推送和提醒
    iCocosSettingItem *push = [iCocosSettingItem itemWithIcon:@"MorePush" title:@"推送和提醒" type:iCocosSettingItemTypeArrow];
    push.operation = ^{
        iCocosPushNoticeViewController *notice = [[iCocosPushNoticeViewController alloc] init];
        [self.navigationController pushViewController:notice animated:YES];
    };
    
    // 1.2.摇一摇机选
    iCocosSettingItem *shake = [iCocosSettingItem itemWithIcon:@"handShake" title:@"摇一摇机选" type:iCocosSettingItemTypeSwitch];
    
    // 1.3.声音效果
    iCocosSettingItem *sound = [iCocosSettingItem itemWithIcon:@"sound_Effect" title:@"声音效果" type:iCocosSettingItemTypeSwitch];
    
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.header = @"基本设置";
    group.items = @[push, shake, sound];
    [_allGroups addObject:group];
}

#pragma mark 添加第1组的模型数据
- (void)add1SectionItems
{
    // 2.1.检查新版本
    iCocosSettingItem *update = [iCocosSettingItem itemWithIcon:@"MoreUpdate" title:@"检查新版本" type:iCocosSettingItemTypeArrow];
    update.operation = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"暂时没有新版本" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    };
    
    // 2.2.帮助
    iCocosSettingItem *help = [iCocosSettingItem itemWithIcon:@"MoreHelp" title:@"帮助" type:iCocosSettingItemTypeArrow];
    help.operation = ^{
        UIViewController *helpVc = [[UIViewController alloc] init];
        helpVc.view.backgroundColor = [UIColor brownColor];
        helpVc.title = @"帮助";
        [self.navigationController pushViewController:helpVc animated:YES];
    };
    
    // 2.3.分享
    iCocosSettingItem *share = [iCocosSettingItem itemWithIcon:@"MoreShare" title:@"分享" type:iCocosSettingItemTypeArrow];
    
    // 2.4.查看消息
    iCocosSettingItem *msg = [iCocosSettingItem itemWithIcon:@"MoreMessage" title:@"查看消息" type:iCocosSettingItemTypeArrow];
    msg.operation = ^{
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        [self presentViewController:guideVC animated:YES completion:nil];
    };
    
    // 2.5.产品推荐
    iCocosSettingItem *product = [iCocosSettingItem itemWithIcon:@"MoreNetease" title:@"产品推荐" type:iCocosSettingItemTypeArrow];
    
    // 2.6.关于
    iCocosSettingItem *about = [iCocosSettingItem itemWithIcon:@"MoreAbout" title:@"关于" type:iCocosSettingItemTypeArrow];
    
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.header = @"高级设置";
    group.footer = @"这的确是高级设置！！！";
    group.items = @[update, help, share, msg, product, about];
    [_allGroups addObject:group];
}
@end