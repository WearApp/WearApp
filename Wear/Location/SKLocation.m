//
//  SKLocation.m
//  Wear
//
//  Created by 孙恺 on 15/7/15.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import "SKLocation.h"
#import <UIKit/UIKit.h>

@interface SKLocation ()

@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) BOOL isFirstUpdate;

@property (nonatomic, strong) NSDictionary *areaidDictionary;

@end

@implementation SKLocation

#pragma mark - Location

- (void)findCurrentLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    //    NSLog(@"locationManager didUpdateLocations2");
    //    NSLog(@"WWLocation didUpdateLocations");
    
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        NSLog(@"isFirstUpdate return");
        return;
    }
    
    if (location.horizontalAccuracy > 0) {
        self.currentLocation = location;
        NSLog(@"当前经度%.4f，纬度%.4f",location.coordinate.longitude,location.coordinate.latitude);
        [self.delegate didGetLocalCoordinate:location.coordinate];
        //        self.updateSucceed = YES;
        //        NSLog(@"Located succeed");
        [self.locationManager stopUpdatingLocation];
        [self transToareaidfromLocation:location];
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch (error.code) {
        case 0:
            NSLog(@"定位失败，正在重试");
            [self.delegate didFailGetCurrentLocationWithError:error];
            [self findCurrentLocation];
            break;
        default:
            NSLog(@"loca failed with error:%@",error.localizedDescription);
            [self.delegate didFailGetCurrentLocationWithError:error];
            [self findCurrentLocation];
            break;
    }
}

#pragma mark - Geocode

- (void)transToareaidfromLocation:(CLLocation *)location {
    //    NSLog(@"%f,%f",location.coordinate.latitude,location.coordinate.longitude);
    
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            //            NSLog(@"locationManager if stage3");
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            self.locationName = placemark.name;
            self.district = placemark.subLocality;
            self.city = placemark.locality;
            self.province = placemark.administrativeArea;
            self.country = placemark.country;
            self.ISOcountryCode = placemark.ISOcountryCode;
            NSLog(@"-----------------------------------");
            NSLog(@"province:%@",self.province);
            NSLog(@"city:%@",self.city);
            NSLog(@"district:%@",self.district);
            NSLog(@"locationName:%@",self.locationName);
            
            self.areaid = _areaidDictionary[self.province];
            NSLog(@"areaid:%@",self.areaid);
            
            [self.delegate didGetLocalAreaID:_areaidDictionary[placemark.administrativeArea] ISOcountryCode:placemark.ISOcountryCode country:placemark.country province:placemark.administrativeArea city:placemark.locality district:placemark.subLocality locationName:placemark.name];
            
            [self.locationManager stopUpdatingLocation];
            
        } else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No location results were returned");
        } else if (error != nil) {
            switch (error.code) {
                case 8:
                    NSLog(@"请联网");
                    [self.delegate didFailGeocodeWithError:error];
                    break;
                default:
                    [self.delegate didFailGeocodeWithError:error];
                    NSLog(@"An error occurred:%@",error.localizedDescription);
                    break;
            }
        }
    }];
}

#pragma mark - Init

+ (instancetype)shareManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        self.areaid = nil;
        self.isFirstUpdate = YES;
        
        //        self.isFirstUpdate = YES;//
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
        _areaidDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        //        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //        _session = [NSURLSession sessionWithConfiguration:config];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    return self;
}


@end
