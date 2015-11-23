//
//  SKAMapLocation.m
//  Wear
//
//  Created by 孙恺 on 15/7/15.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import "SKAMapLocation.h"
#import <UIKit/UIKit.h>

@interface SKAMapLocation ()

@property (strong, nonatomic) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

@implementation SKAMapLocation

#pragma mark - Call

- (void)findCurrentLocation {
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

#pragma mark - Init

- (void)initAMapLocationKit {
    [[AMapLocationServices sharedServices] setApiKey:@"acbfeeb790796758ca5021b370f618e9"];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self initCompleteBlock];
}

- (void)initCompleteBlock
{
    __weak SKAMapLocation *wSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            [wSelf.delegate didFailLocationWithError:error];
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        if (location)
        {
            wSelf.locatedSuccess = YES;
            if (regeocode)
            {
                [wSelf.delegate didGetAddress:regeocode.formattedAddress];
                [wSelf.delegate didGetLocalCoordinate:location.coordinate];
                [wSelf.delegate didGetLocalAreaID:[wSelf getAreaidWithCityName:regeocode.city] cityCode:regeocode.citycode districtCode:regeocode.adcode];
                [wSelf.delegate didGetProvince:regeocode.province city:regeocode.city district:regeocode.district];
                [wSelf.delegate didGetAccuracy:location.horizontalAccuracy];
                
//                NSLog(@"%@->%@->%@",regeocode.province, regeocode.city, regeocode.district);
//                NSLog(@"%@-%@-%.2f",regeocode.citycode, regeocode.adcode, location.horizontalAccuracy);
                
            }
            else
            {
                [wSelf.delegate didGetAccuracy:location.horizontalAccuracy];
                [wSelf.delegate didGetLocalCoordinate:location.coordinate];
//                NSLog(@"lat:%f;lon:%f;",location.coordinate.latitude, location.coordinate.longitude);
//                NSLog(@"accuracy:%.2fm",location.horizontalAccuracy);
            }
            
            //            ViewController *sSelf = wSelf;
        }
    };
}

- (NSString *)getAreaidWithCityName:(NSString *)cityName {
    NSDictionary *areaidDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"]];
    return areaidDictionary[cityName];
}

#pragma mark - Lifecycle

+ (instancetype)shareManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initAMapLocationKit];
        self.locatedSuccess = NO;
    }
    return self;
}


@end
