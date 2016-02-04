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
    [self.tableView.topRefresh setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Refreshing

- (void)topRefreshing{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView.topRefresh endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundGauss"]]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSLog(@"egg");
    [self setupSettingRefreshing];
//    [self.scrollView setContentSize:[UIScreen mainScreen].bounds.size];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - tableview

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    switch (indexPath.row) {
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://blog.talisk.cn"]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://buhuan.github.io"]];
            break;
        case 6:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wearapp.github.io"]];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/8.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    switch (indexPath.row) {
        case 1:
            [cell.textLabel setText:@"你找到了彩蛋！"];
            break;
        case 2:
            [cell.textLabel setText:@"开发者的博客：talisk"];
            break;
        case 3:
            [cell.textLabel setText:@"设计师的博客：buhuan"];
            break;
        case 5:
            [cell.textLabel setText:@"欢迎访问项目主页："];
            break;
        case 6:
            [cell.textLabel setText:@"点击访问：http://wearapp.github.io/"];
            break;
            
        default:
            break;
    }
    
    [cell setBackgroundColor:[SKChromatography temperatureColorWithHue:255-(indexPath.row+1)*30 alpha:0.7]];
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
