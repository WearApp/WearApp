//
//  CardViewController.m
//  Wear
//
//  Created by 孙恺 on 15/11/9.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "CardViewController.h"
#import <STPopup/STPopup.h>
#import "CardDetailTableViewCell.h"
#import "SKChromatography.h"
#import "SKWear.h"

#import "LazyPageScrollView.h"
#import "TodayCardView.h"
#import "ForecastCardView.h"
#import "TrendCardView.h"

#import "OAStackView.h"

#import "TodayEquipmentTableViewCell.h"
#import "ForecastTableViewCell.h"
#import "GraphHeadTableViewCell.h"

#import <GraphKit/GraphKit.h>

@interface CardViewController ()<UITableViewDataSource, UITableViewDelegate, LazyPageScrollViewDelegate, GKLineGraphDataSource>

@property (strong, nonatomic) TodayCardView *todayView;
@property (strong, nonatomic) ForecastCardView *forecastView;
@property (strong, nonatomic) TrendCardView *trendView;

@property (nonatomic, strong) NSArray *graphDataArray;
@property (nonatomic, strong) NSArray *graphLabelsArray;

@property (strong, nonatomic) IBOutlet LazyPageScrollView *pageView;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *mainIconImageView;

@end

@implementation CardViewController

- (instancetype)init
{
    if (self = [super init]) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        self.weather = [[SKAPIStoreWeatherModel alloc] init];
        
        self.contentSizeInPopup = CGSizeMake(screenSize.width/5*4, screenSize.height/5*3);
        self.landscapeContentSizeInPopup = CGSizeMake(screenSize.height/5*4, screenSize.width/5*3);
        self.draggable = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.popupController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.popupController.navigationBar.barStyle = UIBarStyleBlack;
    self.popupController.navigationBar.translucent = NO;
    [self.popupController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.weather.city;
    [self.view setBackgroundColor:[self.popupController.navigationBar.barTintColor colorWithAlphaComponent:1]];
    
    [self setupLazyPage];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    [self.descriptionLabel setText:[NSString stringWithFormat:@"当前:%@,%@%@ 空气指数:%@",self.weather.today.currentTemp, self.weather.today.windDirection, self.weather.today.windLevel, self.weather.today.aqi]];
//    
//    NSInteger low = [self.weather.today.tempLow substringWithRange:NSMakeRange((0), self.weather.today.tempLow.length-1)].integerValue;
//    NSInteger hi = [self.weather.today.tempHigh substringWithRange:NSMakeRange((0), self.weather.today.tempHigh.length-1)].integerValue;
//    
//    [self.mainIconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"wear%li",[SKWear wearIndexWithTemperatureHigh:hi temperatureLow:low]]]];
//
//    NSLog(@"传参成功%@",self.weather);
//
//    [self.view setBackgroundColor:[self.popupController.navigationBar.barTintColor colorWithAlphaComponent:1]];
//    
//    [self setupTableView];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - LazyPage Setup

- (void)setupLazyPage {
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50 TabHeight:40 VerticalDistance:0 BkColor:[UIColor clearColor]];
    
    [self setupTodayPage];
    [self setupForecastPage];
    [self setupTrendPage];
    
    [_pageView enableTabBottomLine:YES LineHeight:3 LineColor:[UIColor whiteColor] LineBottomGap:5 ExtraWidth:10];
    [_pageView setTitleStyle:[UIFont systemFontOfSize:15] Color:[UIColor colorWithWhite:0.85 alpha:1] SelColor:[UIColor whiteColor]];
    [_pageView enableBreakLine:NO Width:1 TopMargin:0 BottomMargin:0 Color:[UIColor groupTableViewBackgroundColor]];
    
    [_pageView generate];
    
    [_pageView setSelectedIndex:0];
}



#pragma mark - LazyPage Delegate
-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    NSLog(@"%ld %ld",preIndex,index);
    
    if (index==2) {
        [((GraphHeadTableViewCell *)([self.trendView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]])).graphView reset];
        [((GraphHeadTableViewCell *)([self.trendView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]])).graphView draw];
    }
    
}


-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
    if(bLeft)
    {
        NSLog(@"left");
    }
    else
    {
        NSLog(@"right");
    }
}

#pragma mark - Pages Setup

- (void)setupTodayPage {
    self.todayView=[TodayCardView viewFromNIB];
    [_pageView addTab:@"今天" View:self.todayView];
    
    [self setupTodayViewTable];
    
}

- (void)setupForecastPage {
    self.forecastView=[ForecastCardView viewFromNIB];
    [_pageView addTab:@"预报" View:self.forecastView];
    
    [self setupForecastViewTable];
    
}

- (void)setupTrendPage {
    self.trendView=[TrendCardView viewFromNIB];
    [_pageView addTab:@"趋势" View:self.trendView];
    
    [self setupTrendViewTable];
}

#pragma mark - TableView

#pragma mark TableView Setup

- (void)setupTodayViewTable {
    [self.todayView.tableView setTag:0];
    
    [self.todayView.tableView setDelegate:self];
    [self.todayView.tableView setDataSource:self];
    [self.todayView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.todayView.wearImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"wear%li",[SKWear wearIndexWithTemperatureHigh:[self.weather.today.tempHigh substringWithRange:NSMakeRange(0, self.weather.today.tempHigh.length-1)].floatValue temperatureLow:[self.weather.today.tempLow substringWithRange:NSMakeRange(0, self.weather.today.tempLow.length-1)].floatValue]]]];
    
    [self.todayView.currentTempLabel setText:self.weather.today.currentTemp];
    [self.todayView.conditionLabel setText:self.weather.today.condition];
}

- (void)setupForecastViewTable {
    [self.forecastView.tableView setTag:1];
    
    [self.forecastView.tableView setDelegate:self];
    [self.forecastView.tableView setDataSource:self];
    [self.forecastView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.forecastView.tableView setSeparatorColor:[UIColor whiteColor]];
    [self.forecastView.tableView setSeparatorInset:UIEdgeInsetsMake(0, 44, 0, 44)];
//    self.forecastView.tableView setSeparatorEffect:[UIVisualEffect ]
}



- (void)setupTrendViewTable {
    [self.trendView.tableView setTag:2];
    
    [self.trendView.tableView setDelegate:self];
    [self.trendView.tableView setDataSource:self];
    [self.trendView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

#pragma mark - TrendView Graph

- (NSNumber *)removeLastCharacter:(NSString *)string {
    return [NSNumber numberWithInteger:[string substringWithRange:NSMakeRange(0, string.length-1)].integerValue];
}

- (void)setupGraphData {
    NSMutableArray *tempHighArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempLowArray = [[NSMutableArray alloc] init];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    for (int i=4; i<7; ++i) {
        [tempHighArray addObject:[self removeLastCharacter:self.weather.history[i].tempHigh]];
        [tempLowArray addObject:[self removeLastCharacter:self.weather.history[i].tempLow]];
        [labels addObject:[NSString stringWithFormat:@"周%@",([self.weather.history[i].week isEqualToString:@"星期天"]?@"日":[self.weather.history[i].week substringWithRange:NSMakeRange(2, 1)])]];
    }
    
    [tempHighArray addObject:[self removeLastCharacter:self.weather.today.tempHigh]];
    [tempLowArray addObject:[self removeLastCharacter:self.weather.today.tempLow]];
    [labels addObject:@"今天"];
    for (int i=0; i<3; ++i) {
        [tempHighArray addObject:[self removeLastCharacter:self.weather.forecast[i].tempHigh]];
        [tempLowArray addObject:[self removeLastCharacter:self.weather.forecast[i].tempLow]];
        [labels addObject:[NSString stringWithFormat:@"周%@",([self.weather.forecast[i].week isEqualToString:@"星期天"]?@"日":[self.weather.forecast[i].week substringWithRange:NSMakeRange(2, 1)])]];
    }
    
    NSLog(@"%@\n%@",tempHighArray, tempLowArray);
    
    self.graphDataArray = @[tempHighArray,tempLowArray];
    self.graphLabelsArray = [NSArray arrayWithArray:labels];
}

#pragma mark - GKLineGraphDataSource

- (NSInteger)numberOfLines {
    return [self.graphDataArray count];
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[[UIColor colorWithRed:1 green:1 blue:210.0/255.0 alpha:1],
                  [UIColor colorWithRed:226.0/255 green:1 blue:244.0/255.0 alpha:1],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_sunflowerColor]
                  ];
    return [colors objectAtIndex:index];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self.graphDataArray objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return [[@[@1, @1.6, @2.2, @1.4] objectAtIndex:index] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [self.graphLabelsArray objectAtIndex:index];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case 0: {
            return tableView.frame.size.height/6;
        }break;
        case 1:{
            return tableView.frame.size.height/3;
        }break;
        case 2:{
            if (!indexPath.row) {
                return self.view.frame.size.width/16*11+8;
            }else {
                return tableView.frame.size.height/10;
            }
        }break;
        default:
            break;
    }
    return 0;
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case 0: {
            return 6;
        }break;
        case 1:{
            return 3;
        }break;
        case 2:{
            return 8;
        }break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case 0: {
            
            if (indexPath.row==5) {
                
                TodayEquipmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"equipmentCell"];
                
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TodayEquipmentTableViewCell" owner:self options:nil] lastObject];
                }
                
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                [cell setTintColor:[UIColor whiteColor]];
                
                UIImageView *icon1 = [SKWear equipmentIndexWithConditionText:@"101" equipmentType:mask]?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"equipment1"]]:nil;
                UIImageView *icon2 = [SKWear equipmentIndexWithConditionText:@"中雨" equipmentType:umbrella]?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"equipment2"]]:nil;
                UIImageView *icon3 = [SKWear equipmentIndexWithConditionText:@"强" equipmentType:sunscreen]?[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"equipment3"]]:nil;
                
                [icon1 setFrame:CGRectMake(0, 0, 18, 18)];
                [icon2 setFrame:CGRectMake(0, 0, 18, 18)];
                [icon3 setFrame:CGRectMake(0, 0, 18, 18)];
                
                [icon1 setContentMode:UIViewContentModeScaleAspectFit];
                [icon2 setContentMode:UIViewContentModeScaleAspectFit];
                [icon3 setContentMode:UIViewContentModeScaleAspectFit];
                
                
                for (UIView *view in cell.stackView.subviews) {
                    [cell.stackView removeArrangedSubview:view];
                }
                
                NSInteger iconCount = 0;
                
                if (icon1) {
                    [cell.stackView addArrangedSubview:icon1];
                    iconCount++;
                }
                if (icon2) {
                    [cell.stackView addArrangedSubview:icon2];
                    iconCount++;
                }
                if (icon3) {
                    [cell.stackView addArrangedSubview:icon3];
                    iconCount++;
                }
                
                [cell.stackViewWidthConstraints setConstant:iconCount*18+(iconCount-1)*16];
                return cell;
            } else {
            
                UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell0"];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                [cell setTintColor:[UIColor whiteColor]];
                [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
                
                [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
                [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:19]];
                switch (indexPath.row) {
                    case 0:
                        [cell.textLabel setText:@"天气状况"];
                        [cell.detailTextLabel setText:self.weather.today.condition];
                        break;
                    case 1:
                        [cell.textLabel setText:@"温度"];
                        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@", self.weather.today.tempLow, self.weather.today.tempHigh]];
                        break;
                    case 2:
                        [cell.textLabel setText:@"风力"];
                        [cell.detailTextLabel setText:self.weather.today.windLevel];
                        break;
                    case 3:
                        [cell.textLabel setText:@"风向"];
                        [cell.detailTextLabel setText:self.weather.today.windDirection];
                        break;
                    case 4:
                        [cell.textLabel setText:@"空气质量指数"];
                        if (!self.weather.today.aqi) {
                            [cell.detailTextLabel setText:@"无数据"];
                        } else {
                            [cell.detailTextLabel setText:self.weather.today.aqi];
                        }
                        break;
                    default:
                        break;
                }
                return cell;
            }
            
        }break;
        case 1:{
            ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ForecastTableViewCell" owner:self options:nil] lastObject];
            }
            
            SKAPIStoreOtherDayModel *dayWeather = self.weather.forecast[indexPath.row+1];
            
            cell.backgroundColor = [UIColor clearColor];

            [cell.dateLabel setText:[NSString stringWithFormat:@"%@ %@",dayWeather.date, dayWeather.week]];

            NSInteger low = [dayWeather.tempLow substringWithRange:NSMakeRange((0), dayWeather.tempLow.length-1)].integerValue;
            NSInteger hi = [dayWeather.tempHigh substringWithRange:NSMakeRange((0), dayWeather.tempHigh.length-1)].integerValue;
            [cell.wearIconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"wear%li",(long)[SKWear wearIndexWithTemperatureHigh:hi temperatureLow:low]]]];
            
            [cell.temperatureLabel setText:[NSString stringWithFormat:@"%@-%@", dayWeather.tempLow, dayWeather.tempHigh]];
            [cell.conditionLabel setText:dayWeather.condition];
            [cell.windDirectionLabel setText:[NSString stringWithFormat:@"%@%@",dayWeather.windDirection, dayWeather.windLevel]];
            
            return cell;
        }break;
        case 2:{
            if (!indexPath.row) {
                GraphHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"graphHeadCell"];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"GraphHeadTableViewCell" owner:self options:nil] lastObject];
                }
                
                self.edgesForExtendedLayout = UIRectEdgeNone;
                
                [self setupGraphData];
                
                cell.graphView.dataSource = self;
                cell.graphView.lineWidth = 3.0;
                
                cell.graphView.valueLabelCount = 4;
                
                [cell.graphView draw];
                [cell.graphView reset];
                [cell.graphView draw];
                
                [cell.graphView setBackgroundColor:[UIColor clearColor]];
                
                [cell setBackgroundColor:[UIColor clearColor]];
                return cell;
            }
            
            UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"trendCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            [cell setTintColor:[UIColor whiteColor]];
            [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:19]];
            
            
            if (indexPath.row>0&&indexPath.row<4) {
                [cell.textLabel setText:self.weather.history[indexPath.row+3].week];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@-%@ %@", self.weather.history[indexPath.row+3].tempLow, self.weather.history[indexPath.row+3].tempHigh, self.weather.history[indexPath.row+3].condition]];
//            } else if (indexPath.row>4&&indexPath.row<8) {
//                [cell.textLabel setText:self.weather.forecast[indexPath.row-5].date];
//                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@-%@ %@", self.weather.forecast[indexPath.row-5].tempLow, self.weather.forecast[indexPath.row-5].tempHigh, self.weather.forecast[indexPath.row-5].condition]];
//            } else {
//                [cell.textLabel setText:@"今天"];
//                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@-%@ %@", self.weather.today.tempLow, self.weather.today.tempHigh, self.weather.today.condition]];
//            }
                
            }else {
                if (indexPath.row-4==0) {
                    [cell.textLabel setText:@"今天"];
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@-%@ %@", self.weather.forecast[indexPath.row-4].tempLow, self.weather.forecast[indexPath.row-4].tempHigh, self.weather.forecast[indexPath.row-4].condition]];
                } else {
                    [cell.textLabel setText:self.weather.forecast[indexPath.row-5].week];
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@-%@ %@", self.weather.forecast[indexPath.row-5].tempLow, self.weather.forecast[indexPath.row-5].tempHigh, self.weather.forecast[indexPath.row-5].condition]];
                }
                
            }
            
            return cell;
        }break;
        default:
            break;
    }
    
    return nil;
    
    
    
//    CardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardDetailCell"];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"CardDetailTableViewCell" owner:self options:nil] lastObject];
//    }
//    //    [cell setAlpha:0.4f];
//    if (indexPath.row<7) {
//        NSInteger low = [self.weather.history[indexPath.row].tempLow substringWithRange:NSMakeRange((0), self.weather.history[indexPath.row].tempLow.length-1)].integerValue;
//        NSInteger hi = [self.weather.history[indexPath.row].tempHigh substringWithRange:NSMakeRange((0), self.weather.history[indexPath.row].tempHigh.length-1)].integerValue;
//        
//        [cell setLeftText:self.weather.history[indexPath.row].date rightText:[NSString stringWithFormat:@"%@-%@ %@",self.weather.history[indexPath.row].tempLow, self.weather.history[indexPath.row].tempHigh, self.weather.history[indexPath.row].condition]];
//        [cell setBackgroundColor:[SKChromatography temperatureColorWithHue:340-(((float)(low+hi))/2+10)*8.8 alpha:0.7f]];
//    } else {
//        if (indexPath.row==7) {
//            NSInteger low = [self.weather.today.tempLow substringWithRange:NSMakeRange((0), self.weather.today.tempLow.length-1)].integerValue;
//            NSInteger hi = [self.weather.today.tempHigh substringWithRange:NSMakeRange((0), self.weather.today.tempHigh.length-1)].integerValue;
//            [cell setBackgroundColor:[SKChromatography temperatureColorWithHue:340-(((float)(low+hi))/2+10)*8.8 alpha:0.7f]];
//            [cell setLeftText:@"今天" rightText:[NSString stringWithFormat:@"%@-%@ %@",self.weather.today.tempLow, self.weather.today.tempHigh, self.weather.today.condition]];
//        } else {
//            NSInteger low = [self.weather.forecast[indexPath.row-8].tempLow substringWithRange:NSMakeRange((0), self.weather.forecast[indexPath.row-8].tempLow.length-1)].integerValue;
//            NSInteger hi = [self.weather.forecast[indexPath.row-8].tempHigh substringWithRange:NSMakeRange((0), self.weather.forecast[indexPath.row-8].tempHigh.length-1)].integerValue;
//            
//            [cell setLeftText:self.weather.forecast[indexPath.row-8].date rightText:[NSString stringWithFormat:@"%@-%@ %@",self.weather.forecast[indexPath.row-8].tempLow, self.weather.forecast[indexPath.row-8].tempHigh, self.weather.forecast[indexPath.row-8].condition]];
//            [cell setBackgroundColor:[SKChromatography temperatureColorWithHue:340-(((float)(low+hi))/2+10)*8.8 alpha:0.7f]];
//        }
//    }
}




/*

#pragma mark - tableview



- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    NSLog(@"%f",self.tableView.rowHeight);
    [self.tableView setContentOffset:CGPointMake(0, 200) animated:YES];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardDetailCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CardDetailTableViewCell" owner:self options:nil] lastObject];
    }
//    [cell setAlpha:0.4f];
    if (indexPath.row<7) {
        NSInteger low = [self.weather.history[indexPath.row].tempLow substringWithRange:NSMakeRange((0), self.weather.history[indexPath.row].tempLow.length-1)].integerValue;
        NSInteger hi = [self.weather.history[indexPath.row].tempHigh substringWithRange:NSMakeRange((0), self.weather.history[indexPath.row].tempHigh.length-1)].integerValue;
        
        [cell setLeftText:self.weather.history[indexPath.row].date rightText:[NSString stringWithFormat:@"%@-%@ %@",self.weather.history[indexPath.row].tempLow, self.weather.history[indexPath.row].tempHigh, self.weather.history[indexPath.row].condition]];
        [cell setBackgroundColor:[SKChromatography temperatureColorWithHue:340-(((float)(low+hi))/2+10)*8.8 alpha:0.7f]];
    } else {
        if (indexPath.row==7) {
            NSInteger low = [self.weather.today.tempLow substringWithRange:NSMakeRange((0), self.weather.today.tempLow.length-1)].integerValue;
            NSInteger hi = [self.weather.today.tempHigh substringWithRange:NSMakeRange((0), self.weather.today.tempHigh.length-1)].integerValue;
            [cell setBackgroundColor:[SKChromatography temperatureColorWithHue:340-(((float)(low+hi))/2+10)*8.8 alpha:0.7f]];
            [cell setLeftText:@"今天" rightText:[NSString stringWithFormat:@"%@-%@ %@",self.weather.today.tempLow, self.weather.today.tempHigh, self.weather.today.condition]];
        } else {
            NSInteger low = [self.weather.forecast[indexPath.row-8].tempLow substringWithRange:NSMakeRange((0), self.weather.forecast[indexPath.row-8].tempLow.length-1)].integerValue;
            NSInteger hi = [self.weather.forecast[indexPath.row-8].tempHigh substringWithRange:NSMakeRange((0), self.weather.forecast[indexPath.row-8].tempHigh.length-1)].integerValue;
            
            [cell setLeftText:self.weather.forecast[indexPath.row-8].date rightText:[NSString stringWithFormat:@"%@-%@ %@",self.weather.forecast[indexPath.row-8].tempLow, self.weather.forecast[indexPath.row-8].tempHigh, self.weather.forecast[indexPath.row-8].condition]];
            [cell setBackgroundColor:[SKChromatography temperatureColorWithHue:340-(((float)(low+hi))/2+10)*8.8 alpha:0.7f]];
        }
    }
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
