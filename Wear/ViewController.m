//
//  ViewController.m
//  Wear
//
//  Created by 孙恺 on 15/10/11.
//  Copyright © 2015年 sunkai. All rights reserved.
//

//#import "CardRootViewController.h"
//#import "YQViewController.h"

//#import "SKLocation.h"

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
//SWIFT_CLASS(CFCityPickerVC);

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, SKAMapLocationDelegate, LFindLocationViewControllerDelegete>

@property (strong, nonatomic) NSMutableArray<NSString *> *cityList;
@property (strong, nonatomic) NSMutableArray<SKAPIStoreWeatherModel *> *cityArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<SKAPIStoreWeatherModel *> *cities;
@property (strong, nonatomic) NSUserDefaults *defaults;

@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;

@property (nonatomic) BOOL hasLocalCell;

@property BOOL finishedLoad;

@property (strong, nonatomic) NSMutableArray *shareIconList;
@property (strong, nonatomic) NSMutableArray *shareTextList;

@property (strong, nonatomic) NSMutableArray<MGSwipeButton *> *shareButtonList;

@end

@implementation ViewController {
    CGFloat screenWidth, screenHeight;
}

#pragma mark - HeaderView

- (void)headerViewSet {
    self.hasLocalCell = YES;
    
    HeaderView *headerView = [HeaderView instantiateFromNib];
    
    [headerView setCityName:@"黄石" temperarute:@"16" tempLow:@"14" tempHigh:@"17"];
    
    [self.tableView setParallaxHeaderView:headerView
                                     mode:VGParallaxHeaderModeFill
                                   height:[UIScreen mainScreen].bounds.size.height/8.0*3.0];
    
//    UILabel *stickyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    stickyLabel.backgroundColor = [UIColor colorWithRed:1 green:0.749 blue:0.976 alpha:1];
//    stickyLabel.textAlignment = NSTextAlignmentCenter;
//    stickyLabel.text = @"Say hello to Sticky View :)";
    
    self.tableView.parallaxHeader.stickyViewPosition = VGParallaxHeaderStickyViewPositionBottom;
    
    headerView.userInteractionEnabled = YES;
    TapHeaderGestureRecognizer *tap = [[TapHeaderGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(presentCardColor:)];
    [tap setValue:headerView.backgroundColor forKey:@"color"];
    [headerView addGestureRecognizer:tap];
    
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
        [popupController.navigationBar setTintColor:[UIColor whiteColor]];
        [popupController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    } else {
        [popupController.navigationBar setBarTintColor:[UIColor whiteColor]];
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

- (void)didGetLocalAreaID:(NSString *)areaid cityCode:(NSString *)cityCode districtCode:(NSString *)districtCode {
    NSLog(@"%@,%@,%@", areaid, cityCode, districtCode);
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


# pragma mark - Refresh Control

-(void)setupRefreshControl{
    
    self.sunnyRefreshControl = [[YALSunnyRefreshControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/3)];
    [self.sunnyRefreshControl attachToScrollView:self.tableView];
}

#pragma mark - Lifecycle

- (void)wipeData {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [HMFileManager removeFileByFileName:@"cities"];
    [HMFileManager removeAllFiles];
//    [HMFileManager removeAllFilesExcept:@"cities.plist"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    
//    [self setupRefreshControl];
    
    [self setupShareList];
    
    [self headerViewSet];
    
//    [self.sunnyRefreshControl beginRefreshing];
    
    self.finishedLoad = NO;
    
    [self wipeData];
    
    [self tableViewSet];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        self.cities = [NSMutableArray array];
    }else{
        NSLog(@"已经不是第一次启动了");
        self.cities = [HMFileManager getObjectByFileName:@"cities"];
    }
    
    [self wipeData];
    
//    self.defaults = [NSUserDefaults standardUserDefaults];
//    
//    self.cities = [NSMutableArray arrayWithArray:[self.defaults arrayForKey:@"cities"]];
    
//    [defaults removeObjectForKey:@"cityList"];
    
//    self.cityList = [[NSMutableArray alloc] init];
//    self.cityList = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"cityList"]];
//    
//    self.cityArray = [[NSMutableArray alloc] init];
//    
//    for (int i=0; i<self.cityList.count; ++i) {
//        SKAPIStoreWeatherModel *model = [[SKAPIStoreWeatherModel alloc] init];
//        [self.cityArray insertObject:model atIndex:0];
//    }
//    
//    [self refreshCityModel];
    
//    [SKAMapLocation shareManager].delegate = self;
//    [[SKAMapLocation shareManager] findCurrentLocation];
    
//    CFCityPickerVC *pickerVC = [[CFCityPickerVC alloc] init];
    
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

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 10.0;
    snapshot.layer.shadowOpacity = 0.6;
    
    return snapshot;
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
        
        LFindLocationViewController *findLocationVC = [[LFindLocationViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:findLocationVC];
        findLocationVC.delegete = self;
        [self presentViewController:nav animated:YES completion:nil];
        
//        ZHPickView *pickView = [[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:YES];
//        [pickView show];
    } else {
    
        CardViewController *cardVC = [[CardViewController alloc] init];
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:cardVC];
        
        [popupController.navigationBar setBarTintColor:[tableView cellForRowAtIndexPath:indexPath].backgroundColor];
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
    
    NSLog(@"111");
    
    [self updateItemAtIndexPath:[NSIndexPath indexPathForRow:self.cities.count inSection:0] withObject:model];
    
    NSLog(@"111");
}

#pragma mark - Util

- (NSString *)getAreaidWithCityName:(NSString *)cityName {
    NSDictionary *areaidDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityName" ofType:@"plist"]];
    return areaidDictionary[cityName];
}

#pragma mark - Refresh City Model

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

- (void)refreshCityModel {
    for (int i=0; i<self.cityList.count; ++i) {
        
        
   
        NSString *areaid = [self getAreaidWithCityName:self.cityList[i]];
//        NSLog(@"%@",self.cityList[i]);
//        NSLog(@"%@",areaid);
        
        [[SKAPIStoreWeatherManager sharedInstance] conditionRequestWithCityid:areaid successBlock:^(SKAPIStoreWeatherModel *model) {
            if (model.errorNumber!=0) {
//                [((WeatherTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:i+1]]) setCityName:self.cityList[i] conditionNum:0 wearSuggestionNum:0 temperatureHi:10 temperatureLow:10];
                [self.cityArray insertObject:model atIndex:0];
//                NSLog(@"%@",self.cityArray[0]);
                self.finishedLoad = YES;
//                NSLog(@"%i",self.cityArray.count);
                
                NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:i inSection:0];
                NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//                NSLog(@"%i",i);
                [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
                
// TODO: 只刷新一行数据
                
                
                
//                NSLog(@"blooo:%@,%@,%@",model.today,model.forecast,model.history);
            } else {
                NSLog(@"error:%@",model.errorNumber);
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"blooo:%@",error.description);
        }];
    }
}

- (void)refreshCity:(NSString *)cityName {
    NSString *areaid = [self getAreaidWithCityName:cityName];
    
    [[SKAPIStoreWeatherManager sharedInstance] conditionRequestWithCityid:areaid successBlock:^(SKAPIStoreWeatherModel *model) {
        if (model.errorNumber!=0) {
            [self.cityArray insertObject:model atIndex:0];
            NSLog(@"blooo:%@,%@,%@",model.today,model.forecast,model.history);
        } else {
            NSLog(@"error:%@",model.errorNumber);
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"blooo:%@",error.description);
    }];
}

@end
