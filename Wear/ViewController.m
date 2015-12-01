//
//  ViewController.m
//  Wear
//
//  Created by 孙恺 on 15/10/11.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "CityListViewController.h"

#import "UIScrollView+VORefresh.h"

#import "iCocosSettingViewController.h"

#import "TapHeaderGestureRecognizer.h"

#import "CommonMarco.h"
#import "XMShareWeiboUtil.h"
#import "XMShareWechatUtil.h"
#import "XMShareQQUtil.h"

#import "YALSunnyRefreshControl.h"

#import "HeaderView.h"
#import "UIScrollView+VGParallaxHeader.h"

#import "HMFileManager.h"

#import "LFindLocationViewController.h"

#import "SKAPIStoreWeatherModel.h"

#import "SKAPIStoreWeatherManager.h"

#import "SKAMapLocation.h"

#import <STPopup/STPopup.h>
#import "CardViewController.h"

#import "ViewController.h"
#import "WeatherTableViewCell.h"
#import "EmptyCell.h"
#import <MGSwipeTableCell.h>
#import <MGSwipeButton.h>

#import <AFNetworking/AFNetworking.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, SKAMapLocationDelegate, LFindLocationViewControllerDelegete, CityListDelegate>

@property (strong, nonatomic) HeaderView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<SKAPIStoreWeatherModel *> *cities;
@property (strong, nonatomic) NSUserDefaults *defaults;

@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;

@property (nonatomic) BOOL hasLocalCell;

@property BOOL finishedLoad;

@property (strong, nonatomic) NSMutableArray *shareIconList;
@property (strong, nonatomic) NSMutableArray *shareTextList;

@property (strong, nonatomic) NSDate *updateDate;

@property (strong, nonatomic) NSMutableArray<MGSwipeButton *> *shareButtonList;

@end

@implementation ViewController {
    CGFloat screenWidth, screenHeight;
}

#pragma mark - Background Fetch

- (void)insertNewObjectForFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (self.updateDate != nil && [self compareDateWithUpdateTime:self.updateDate]) {
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    } else {
    
        NSLog(@"uibackgroundfetch");
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            NSLog(@"wwwwwwwwwff");
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    NSLog(@"无网络");
                    completionHandler(UIBackgroundFetchResultFailed);
                    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                    break;
                }
                case AFNetworkReachabilityStatusUnknown:{
                    completionHandler(UIBackgroundFetchResultFailed);
                    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    NSLog(@"WiFi网络");
                    // Local Weather Refresh
                    [[SKAMapLocation shareManager] setDelegate:self];
                    [[SKAMapLocation shareManager] findCurrentLocation];
                    // Refresh All City
                    [self updateAllCityCell];
                    completionHandler(UIBackgroundFetchResultNewData);
                    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    NSLog(@"无线网络");
                    completionHandler(UIBackgroundFetchResultNoData);
                    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                    break;
                }
                default:
                    break;
            }
        }];
    }
    
//    NSLog(@"Update the tableview.");
//    self.numberOfnewPosts = [self getRandomNumberBetween:0 to:4];
//    NSLog(@"%d new fetched objects",self.numberOfnewPosts);
//    for(int i = 0; i < self.numberOfnewPosts; i++){
//        int addPost = [self getRandomNumberBetween:0 to:(int)([self.possibleTableData count]-1)];
//        [self insertObject:[self.possibleTableData objectAtIndex:addPost]];
//    }
    /*
     At the end of the fetch, invoke the completion handler.
     */

}

#pragma mark - Refreshing

- (void)setupSettingRefreshing {
    [self.tableView addBottomRefreshWithTarget:self action:@selector(bottomRefreshing)];
    
    [self.tableView.bottomRefresh setBackgroundColor:self.headerView.backgroundColor];
    [self.tableView.bottomRefresh setAlpha:0.5];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"上拉打开设置"];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"上拉打开设置"];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:@"释放打开设置"];
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:@"正在打开设置"];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str1.length)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str2.length)];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str3.length)];
    [str4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str4.length)];
    self.tableView.bottomRefresh.refreshTexts = @[str1, str2, str3, str4];
}

- (void)bottomRefreshing{
    NSLog(@"setting");
    
    iCocosSettingViewController *settingVC = [[iCocosSettingViewController alloc] init];
//    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    UITabBarController *tabbarVC = [[UITabBarController alloc] init];
    [tabbarVC addChildViewController:settingVC];
    
    [self presentViewController:tabbarVC animated:YES completion:nil];
    [self.tableView.bottomRefresh endRefreshing];
}

#pragma mark - HeaderView

- (void)headerViewSet {
    
    [[SKAMapLocation shareManager] setDelegate:self];
    [[SKAMapLocation shareManager] findCurrentLocation];
    
    self.hasLocalCell = YES;
    
    self.headerView = [HeaderView instantiateFromNib];
    
    [self.headerView setCityName:@"--" temperarute:@"--" tempLow:@"--" tempHigh:@"--"];

    [self.tableView setParallaxHeaderView:self.headerView
                                     mode:VGParallaxHeaderModeFill
                                   height:((float)[UIScreen mainScreen].bounds.size.height)/8.0*3];
    
//    UILabel *stickyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    stickyLabel.backgroundColor = [UIColor colorWithRed:1 green:0.749 blue:0.976 alpha:1];
//    stickyLabel.textAlignment = NSTextAlignmentCenter;
//    stickyLabel.text = @"Say hello to Sticky View :)";
    
    self.tableView.parallaxHeader.stickyViewPosition = VGParallaxHeaderStickyViewPositionBottom;
    
    self.headerView.userInteractionEnabled = YES;
    TapHeaderGestureRecognizer *tap = [[TapHeaderGestureRecognizer alloc] init];
    [tap setColor:self.headerView.backgroundColor];
    [tap addTarget:self action:@selector(presentCardColor:)];
    [self.headerView addGestureRecognizer:tap];
    
//    [self.tableView.parallaxHeader setStickyView:stickyLabel
//                                      withHeight:40];
}

- (void)presentCardColor:(id)sender {
    
    CardViewController *cardVC = [[CardViewController alloc] init];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:cardVC];
    
    TapHeaderGestureRecognizer *tap = (TapHeaderGestureRecognizer *)sender;
    UIColor *color = [tap valueForKey:@"color"];
    
    if (color) {
        [popupController.navigationBar setBarTintColor:color];
        [popupController.navigationBar setAlpha:1];
        [popupController.navigationBar setTintColor:[UIColor whiteColor]];
        [popupController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    } else {
        [popupController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [popupController.navigationBar setAlpha:1];
        [popupController.navigationBar setTintColor:[UIColor blackColor]];
        [popupController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    }
    
    [popupController setCornerRadius:10.0f];
    
    if (NSClassFromString(@"UIBlurEffect")) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    
    [popupController presentInViewController:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    // Log Parallax Progress
    //NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
}

#pragma mark - SKAmapLocationDelegate

- (void)didGetAccuracy:(CLLocationAccuracy)accuracy {
    NSLog(@"%f",accuracy);
}

- (void)didGetLocalCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"%f,%f",coordinate.latitude, coordinate.longitude);
}

- (void)didGetLocalAreaID:(NSString *)areaid cityName:(NSString *)cityName cityCode:(NSString *)cityCode districtCode:(NSString *)districtCode {
    NSLog(@"%@,%@,%@", areaid, cityCode, districtCode);
    
    
    if (![HMFileManager getObjectByFileName:areaid]) {
        [self.headerView setCityName:@"--" temperarute:0 tempLow:0 tempHigh:0];
        [self refreshLocalWeatherWithCityid:areaid cityName:cityName headerView:self.headerView];
    } else {
        SKAPIStoreWeatherModel *savedModel = [HMFileManager getObjectByFileName:areaid];
        [self.headerView setCityName:savedModel.city temperarute:savedModel.today.currentTemp tempLow:savedModel.today.tempLow tempHigh:savedModel.today.tempHigh];
        
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.cities.count inSection:0]] setBackgroundColor:self.headerView.backgroundColor];
        [self.tableView.bottomRefresh setBackgroundColor:self.headerView.backgroundColor];
        
        if (![self compareDateWithUpdateTime:savedModel.updateTime]) {
            [self refreshLocalWeatherWithCityid:areaid cityName:cityName headerView:self.headerView];
        }
    }
}

- (void)didGetProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
    NSLog(@"%@,%@,%@", province, city, district);
}

- (void)didGetAddress:(NSString *)formattedAddress {
    NSLog(@"%@", formattedAddress);
}

- (void)didFailLocationWithError:(NSError *)error {
    NSLog(@"%li:%@",(long)error.code, error.description);
}

#pragma mark - Local Weather

- (void)refreshLocalWeatherWithCityid:(NSString *)cityid cityName:(NSString *)cityName headerView:(HeaderView *)headerView {
    [[SKAPIStoreWeatherManager sharedInstance] conditionRequestWithCityid:cityid successBlock:^(SKAPIStoreWeatherModel *model) {
        if (model.errorNumber!=0) {
            
            self.updateDate = [NSDate date];
            
            NSLog(@"refreshlocal");
            
            [model setUpdateTime:[NSDate date]];
            NSLog(@"%@", model);
            [headerView setCityName:cityName temperarute:model.today.currentTemp tempLow:model.today.tempLow tempHigh:model.today.tempHigh];
            [((TapHeaderGestureRecognizer *)headerView.gestureRecognizers.firstObject) setColor:headerView.backgroundColor];
            // todo: local weather card color doesn't change
            NSLog(@"%@", (TapHeaderGestureRecognizer *)headerView.gestureRecognizers.firstObject);
            
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.cities.count inSection:0]] setBackgroundColor:headerView.backgroundColor];
            [self.tableView.bottomRefresh setBackgroundColor:self.headerView.backgroundColor];
//            NSLog(@"cell:%@", [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].description);
            
            [HMFileManager saveObject:model byFileName:model.cityid];
        } else {
            NSLog(@"error:%@",model.errorNumber);
        }
    } failureBlock:^(NSError *error) {
        [headerView setBackgroundColor:[UIColor redColor]];
        [headerView setCityName:@"获取失败" temperarute:0 tempLow:0 tempHigh:0];
        NSLog(@"blooo:%@",error.description);
    }];

}


#pragma mark - Refresh Control

-(void)setupRefreshControl{
    
    self.sunnyRefreshControl = [[YALSunnyRefreshControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/3)];
    [self.sunnyRefreshControl attachToScrollView:self.tableView];
}

#pragma mark - Pull to load new vc
//
//- (void)setupScrollView {
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
//    [self addChildViewController:settingsVC];
//    
//    [self.tableView setContentSize:CGSizeMake(0, 631)];
//    if (settingsVC.view != nil) {
////        _scrollView.secondScrollView = detailVC.scrollView;
//        [self.tableView setSecondScrollView:settingsVC.view];
//    }
//    
//}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewdidload");
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorGauss"]]];
    
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    
//    [self setupRefreshControl];
    
    [self setupShareList];
    
    [self headerViewSet];
    
//    [self.sunnyRefreshControl beginRefreshing];
    
    self.finishedLoad = NO;
    
//    [self wipeData];
    
    [self tableViewSet];
    
    [self setupSettingRefreshing];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        self.cities = [NSMutableArray array];
    }else{
        NSLog(@"已经不是第一次启动了");
        self.cities = [HMFileManager getObjectByFileName:@"cities"];
    }

    
//    [self wipeData];
}

// 重用 和 第一次加载

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Set

- (void)tableViewSet {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
}

- (void)modifyConstantWithIndexPath:(NSIndexPath *)indexPath {
    WeatherTableViewCell *cell = (WeatherTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (!indexPath.row && !self.hasLocalCell) {
        [cell.temperatureLabelTopConstant setConstant:20.0f];
//        [cell.conditionImageViewTopConstant setConstant:20.0f];
        [cell.cityNameLabelTopConstant setConstant:20.0f];
//        [cell.activityIndicatorViewTopConstant setConstant:20.0f];
    } else {
        [cell.temperatureLabelTopConstant setConstant:0];
//        [cell.conditionImageViewTopConstant setConstant:0];
        [cell.cityNameLabelTopConstant setConstant:0];
//        [cell.activityIndicatorViewTopConstant setConstant:0];
    }
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
//    if (indexPath.row == self.cities.count+1) {
//        return;
//    }
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                
                sourceIndexPath = indexPath;
                
                WeatherTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98; 
                    
                    // Black out.
//                    cell.backgroundColor = [UIColor grayColor];
                    [cell setHidden:YES];
                } completion:nil]; 
            } 
            break; 
        } 
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                if (indexPath.row == self.cities.count) {
                    break;
                }
                
                // ... update data source.
                [self.cities exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:indexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                [self modifyConstantWithIndexPath:indexPath];
                [self modifyConstantWithIndexPath:sourceIndexPath];

                
                // ... and update source so it is in sync with UI changes. 
                sourceIndexPath = indexPath; 
            } 
            break; 
        }
        default: {
            // Clean up.
            WeatherTableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
//                cell.backgroundColor = [UIColor grayColor];
                [cell setHidden:NO];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview]; 
                snapshot = nil; 
                
            }]; 
            sourceIndexPath = nil; 
            break; 
        }
    }
}

#pragma mark - Share Method

- (void)shareToWeixinSessionWithTitle:(NSString *)title contentText:(NSString *)shareText shareURL:(NSString *)shareURL
{
    
    XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
    util.shareTitle = title;
    util.shareText = shareText;
    util.shareUrl = shareURL;
    
    [util shareToWeixinSession];
    
}

- (void)shareToWeixinTimelineWithTitle:(NSString *)title contentText:(NSString *)shareText shareURL:(NSString *)shareURL
{
    
    XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
    util.shareTitle = title;
    util.shareText = shareText;
    util.shareUrl = shareURL;
    
    [util shareToWeixinTimeline];
    
}

- (void)shareToQQWithTitle:(NSString *)title contentText:(NSString *)shareText shareURL:(NSString *)shareURL
{
    XMShareQQUtil *util = [XMShareQQUtil sharedInstance];
    util.shareTitle = title;
    util.shareText = shareText;
    util.shareUrl = shareURL;
    
    [util shareToQQ];
}

- (void)shareToQzoneWithTitle:(NSString *)title contentText:(NSString *)shareText shareURL:(NSString *)shareURL
{
    XMShareQQUtil *util = [XMShareQQUtil sharedInstance];
    util.shareTitle = title;
    util.shareText = shareText;
    util.shareUrl = shareURL;
    
    [util shareToQzone];
}

- (void)shareToWeiboWithTitle:(NSString *)title contentText:(NSString *)shareText shareURL:(NSString *)shareURL
{
    
    XMShareWeiboUtil *util = [XMShareWeiboUtil sharedInstance];
    util.shareTitle = title;
    util.shareText = shareText;
    util.shareUrl = shareURL;
    
    [util shareToWeibo];
    
}

#pragma mark - Share List

- (NSArray *)getShareListArray {
    NSMutableArray *shareButtonList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.shareTextList.count; ++i) {
        MGSwipeButton *button = [[MGSwipeButton alloc] init];
        button = [MGSwipeButton buttonWithTitle:self.shareTextList[i] icon:[UIImage imageNamed:self.shareIconList[i]] backgroundColor:[UIColor whiteColor] callback:^BOOL(MGSwipeTableCell *sender) {
            
            if ([self.shareTextList[i] isEqualToString:@"wechat"]) {
                [self shareToWeixinSessionWithTitle:@"省心天气" contentText:@"省心天气" shareURL:@"http://wearapp.github.io/"];
            } else if ([self.shareTextList[i] isEqualToString:@"moment"]) {
                [self shareToWeixinTimelineWithTitle:@"省心天气" contentText:@"省心天气" shareURL:@"http://wearapp.github.io/"];
            } else if ([self.shareTextList[i] isEqualToString:@"qq"]) {
                [self shareToQQWithTitle:@"省心天气" contentText:@"省心天气" shareURL:@"http://wearapp.github.io/"];
            } else if ([self.shareTextList[i] isEqualToString:@"qzone"]) {
                [self shareToQzoneWithTitle:@"省心天气" contentText:@"省心天气" shareURL:@"http://wearapp.github.io/"];
            } else {
                [self shareToWeiboWithTitle:@"省心天气" contentText:@"省心天气" shareURL:@"http://wearapp.github.io/"];
            }
            return YES;
        }];
        [button setButtonWidth:[UIScreen mainScreen].bounds.size.width/5];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [shareButtonList addObject:button];
    }
    return [NSArray arrayWithArray:shareButtonList];
}

- (void)setupShareList
{
    
    /**
     *  判断应用是否安装，可用于是否显示
     *  QQ和Weibo分别有网页版登录与分享，微信目前不支持
     */
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    //    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    //    BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]];
    
    self.shareIconList = [[NSMutableArray alloc] init];
    self.shareTextList = [[NSMutableArray alloc] init];
    
    if(hadInstalledWeixin){
        
        [self.shareIconList addObject:@"icon_share_wechat@2x"];
        [self.shareIconList addObject:@"icon_share_moment@2x"];
        [self.shareTextList addObject:@"wechat"];
        [self.shareTextList addObject:@"moment"];
        
    }
    
    //    if(hadInstalledQQ){
    
    [self.shareIconList addObject:@"icon_share_qq@2x"];
    [self.shareIconList addObject:@"icon_share_qzone@2x"];
    [self.shareTextList addObject:@"qq"];
    [self.shareTextList addObject:@"qzone"];
    
    //    }
    
    //    if(hadInstalledWeibo){
    
    [self.shareIconList addObject:@"icon_share_webo@2x"];
    [self.shareTextList addObject:@"weibo"];
    
    //    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count+1;
//    return 17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    
    
    if (indexPath.row==self.cities.count) {
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EmptyCell" owner:self options:nil] lastObject];
        }
        cell.backgroundColor = self.headerView.backgroundColor;
        [cell setAlpha:0.4f];
        UILongPressGestureRecognizer *emptyGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:nil action:nil];
        [cell addGestureRecognizer:emptyGesture];
        return cell;
    } else {
        WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WeatherTableViewCell" owner:self options:nil] lastObject];
        }

        if (![HMFileManager getObjectByFileName:[self getAreaidWithCityName:self.cities[indexPath.row].city]]) {

            [cell setCityName:@"--" conditionNum:0 temperatureHi:0 temperatureLow:0];
            [self refreshCell:cell withIndexPath:indexPath weatherModel:self.cities[indexPath.row]];
        } else {
            SKAPIStoreWeatherModel *savedModel = [HMFileManager getObjectByFileName:[self getAreaidWithCityName:self.cities[indexPath.row].city]];
            [cell setCityName:savedModel.city conditionNum:0 temperatureHi:[savedModel.today.tempHigh intValue] temperatureLow:[savedModel.today.tempLow intValue]];
            
            if (![self compareDateWithUpdateTime:savedModel.updateTime]) {
                [self refreshCell:cell withIndexPath:indexPath weatherModel:self.cities[indexPath.row]];
            }
        }
        
        
        cell.leftButtons = [self getShareListArray];
        cell.leftSwipeSettings.transition = MGSwipeDirectionRightToLeft;

        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"不再关注" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"delete");
            NSIndexPath *deleteIndexPath = [tableView indexPathForCell:sender];
            [self deleteItemAtIndexPath:deleteIndexPath];
            return YES;
        }]];
        cell.rightSwipeSettings.transition = MGSwipeExpansionLayoutCenter;
        
        
        if (!indexPath.row && !self.hasLocalCell) {
            [cell.temperatureLabelTopConstant setConstant:20.0f];
//            [cell.conditionImageViewTopConstant setConstant:20.0f];
            [cell.cityNameLabelTopConstant setConstant:20.0f];
            //        [cell.activityIndicatorViewTopConstant setConstant:20.0f];
        } else {
            [cell.temperatureLabelTopConstant setConstant:0];
//            [cell.conditionImageViewTopConstant setConstant:0];
            [cell.cityNameLabelTopConstant setConstant:0];
            //        [cell.activityIndicatorViewTopConstant setConstant:0];
        }
        return cell;
    }
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self deleteItemAtIndexPath:indexPath];
//}

- (void)animationFinished: (id) sender{
    NSLog(@"animationFinished !");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==self.cities.count) {
//        
//        LFindLocationViewController *findLocationVC = [[LFindLocationViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:findLocationVC];
//        findLocationVC.delegete = self;
//        [self presentViewController:nav animated:YES completion:nil];
        
        CityListViewController *cityListVC = [[CityListViewController alloc] init];
        cityListVC.delegete = self;
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:cityListVC];
        
        [popupController.navigationBar setBarTintColor:[tableView cellForRowAtIndexPath:indexPath].backgroundColor];
        [popupController.navigationBar setAlpha:1];
        [popupController.navigationBar setTintColor:[UIColor whiteColor]];
        [popupController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        [cityListVC.view setBackgroundColor:[tableView cellForRowAtIndexPath:indexPath].backgroundColor];
        
        [popupController setCornerRadius:10.0f];
        
        if (NSClassFromString(@"UIBlurEffect")) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        }
        
        [popupController presentInViewController:self];
        
//        ZHPickView *pickView = [[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:YES];
//        [pickView show];
    } else {
    
        CardViewController *cardVC = [[CardViewController alloc] init];
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:cardVC];
        
        [popupController.navigationBar setBarTintColor:[tableView cellForRowAtIndexPath:indexPath].backgroundColor];
        [popupController.navigationBar setAlpha:1];
        [popupController.navigationBar setTintColor:[UIColor whiteColor]];
        [popupController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        [popupController setCornerRadius:10.0f];
        
        if (NSClassFromString(@"UIBlurEffect")) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        }
        
        [popupController presentInViewController:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.hasLocalCell) {
        return screenHeight/8.0f;
    } else if (!indexPath.row) {
        return screenHeight/8.0f+20.0f;
    } else {
        return screenHeight/8.0f;
    }
}

#pragma mark - City List Delegate

- (void)didSelectCityWithName:(NSString *)cityName {
    NSLog(@">>>>>>>>>>>>%@",cityName);
    
    for (SKAPIStoreWeatherModel *model in self.cities) {
        if ([cityName isEqualToString:model.city]) {
            NSLog(@"已经添加%@", cityName);
            return;
        }
    }
    
    SKAPIStoreWeatherModel *model = [[SKAPIStoreWeatherModel alloc] init];
    model.city = cityName;
    
    NSLog(@"111");
    
    [self updateItemAtIndexPath:[NSIndexPath indexPathForRow:self.cities.count inSection:0] withObject:model];
    
    NSLog(@"111");
}

#pragma mark - LFindLocationViewControllerDelegete

-(void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation
{
    NSLog(@">>>>>>>>>>>>%@",city);
    
    for (SKAPIStoreWeatherModel *model in self.cities) {
        if ([city isEqualToString:model.city]) {
            NSLog(@"已经添加%@", city);
            return;
        }
    }
    
    SKAPIStoreWeatherModel *model = [[SKAPIStoreWeatherModel alloc] init];
    model.city = city;
    
    [self updateItemAtIndexPath:[NSIndexPath indexPathForRow:self.cities.count inSection:0] withObject:model];
}

#pragma mark - Util

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 10.0;
    snapshot.layer.shadowOpacity = 0.6;
    
    return snapshot;
}

/**
 * @brief 判断时间是否失效，如果失效返回假，未失效返回真
 * @param date 需要比较的时间
 */
- (BOOL)compareDateWithUpdateTime:(NSDate *)date {
    NSDate *date8 = [self getCustomDateWithHour:8];
    NSDate *date11 = [self getCustomDateWithHour:11];
    NSDate *date18 = [self getCustomDateWithHour:18];
    if ([[NSDate date] compare:date8]==NSOrderedAscending||[[NSDate date] compare:date8]==NSOrderedSame) {
        // 0 < now <= 8
        // 用date和前一天的晚18点比，如果早于或等于前一天晚18点，返回假，否则返回真。
        NSDate *yesterday18 = [date18 dateByAddingTimeInterval:24*60*60];
        if ([date compare:yesterday18] == NSOrderedAscending||[date compare:yesterday18]==NSOrderedSame) {
            return NO;
        } else {
            return YES;
        }
    } else if ([[NSDate date] compare:date8]==NSOrderedDescending&&([[NSDate date] compare:date11]==NSOrderedAscending||[[NSDate date] compare:date11]==NSOrderedSame)) {
        // 8 < now <= 11
        // 用date和今天8点比，如果早于或等于今天8点，返回假，否则返回真。
        if ([date compare:date8] == NSOrderedAscending||[date compare:date8]==NSOrderedSame) {
            return NO;
        } else {
            return YES;
        }
    } else if ([[NSDate date] compare:date11]==NSOrderedDescending&&([[NSDate date] compare:date18]==NSOrderedAscending||[[NSDate date] compare:date18]==NSOrderedSame)) {
        // 11 < now <= 18
        // 用date和今天11点比，如果早于或等于今天11点，返回假，否则返回真。
        if ([date compare:date11] == NSOrderedAscending||[date compare:date11]==NSOrderedSame) {
            return NO;
        } else {
            return YES;
        }
    } else if ([[NSDate date] compare:date18]==NSOrderedDescending) {
        // 18 < now < 24
        // 用date和今天18点比，如果早于或等于今天18点，返回假，否则返回真。
        if ([date compare:date18] == NSOrderedAscending||[date compare:date18]==NSOrderedSame) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

/**
 * @brief 返回某个地点对应的区域编号，NSString类型
 * @param cityName 某个地点名称，不含区域等级类型，如天津（不是天津市），北辰（不是北辰区）
 */
- (NSString *)getAreaidWithCityName:(NSString *)cityName {
    NSDictionary *areaidDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chinaCodeList" ofType:@"plist"]];
    return areaidDictionary[cityName];
}

/**
 * @brief 清除应用文件归档数据以及设置为应用首次启动
 */
- (void)wipeData {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [HMFileManager removeFileByFileName:@"cities"];
    [HMFileManager removeAllFiles];
    //    [HMFileManager removeAllFilesExcept:@"cities.plist"];
}


#pragma mark - Refresh City Model

- (void)updateAllCityCell {
    for (int i = 0; i<self.cities.count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self refreshCell:[self.tableView cellForRowAtIndexPath:indexPath] withIndexPath:indexPath weatherModel:self.cities[i]];
        NSLog(@"后台刷新%@的数据", self.cities[i].city);
    }
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath withObject:(SKAPIStoreWeatherModel *)object {
    [self.tableView beginUpdates];
    if (object) {
        [self.cities insertObject:object atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [HMFileManager saveObject:self.cities byFileName:@"cities"];
    }
    [self.tableView endUpdates];
}

- (void)refreshCell:(WeatherTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath weatherModel:(SKAPIStoreWeatherModel *)oldModel {
    [[SKAPIStoreWeatherManager sharedInstance] conditionRequestWithCityid:[self getAreaidWithCityName:oldModel.city] successBlock:^(SKAPIStoreWeatherModel *model) {
        
        self.updateDate = [NSDate date];
        
        if (model.errorNumber!=0) {
            [model setUpdateTime:[NSDate date]];
            NSLog(@"%@", model);
            [cell setCityName:model.city conditionNum:0 temperatureHi:[model.today.tempHigh intValue] temperatureLow:[model.today.tempLow intValue]];
//            [cell.activityIndicator stopAnimating];
            [HMFileManager saveObject:model byFileName:model.cityid];
        } else {
            NSLog(@"error:%@",model.errorNumber);
        }
    } failureBlock:^(NSError *error) {
        [cell setBackgroundColor:[UIColor redColor]];
        [cell setCity:@"错误"];
        NSLog(@"blooo:%@",error.description);
    }];
}


- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.cities removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [HMFileManager saveObject:self.cities byFileName:@"cities"];
    [self.tableView endUpdates];
}

@end
