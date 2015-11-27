//
//  EggsViewController.m
//  Wear
//
//  Created by 孙恺 on 15/11/23.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "UIScrollView+VORefresh.h"
#import "EggsViewController.h"
#import "SKChromatography.h"

@interface EggsViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation EggsViewController

- (void)setupSettingRefreshing {
    [self.tableView removeTopRefresh];
    [self.tableView addTopRefreshWithTarget:self action:@selector(topRefreshing)];
    NSLog(@"addtoprefresh");
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"下拉返回"];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"下拉返回"];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:@"释放返回"];
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:@"正在返回"];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str1.length)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, str2.length)];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(0, str3.length)];
    [str4 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, str4.length)];
    self.tableView.topRefresh.refreshTexts = @[str1, str2, str3, str4];
}

#pragma mark - Refreshing

- (void)topRefreshing{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView.topRefresh endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSLog(@"egg");
    [self setupSettingRefreshing];
//    [self.scrollView setContentSize:[UIScreen mainScreen].bounds.size];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/8.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row==4) {
        [cell.textLabel setText:@"感谢设计师梁晓怡女士"];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.backgroundColor = [UIColor redColor];
    [cell setBackgroundColor:[SKChromatography temperatureColorWithHue:255-(indexPath.row+1)*30]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
