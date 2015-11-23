//
//  SKLocation.h
//  Wear
//
//  Created by 孙恺 on 15/7/15.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol SKLocationDelegate <NSObject>

@optional

- (void)didGetLocalCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)didGetLocalAreaID:(NSString *)areaid ISOcountryCode:(NSString *)ISOcountryCode country:(NSString *)country province:(NSString *)province city:(NSString *)city district:(NSString *)district locationName:(NSString *)locationName;

- (void)didFailGetCurrentLocationWithError:(NSError *)error;
- (void)didFailGeocodeWithError:(NSError *)error;

@end

@interface SKLocation : NSObject<CLLocationManagerDelegate>

// Location information
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *ISOcountryCode;
@property (nonatomic, strong) NSString *areaid;

@property (nonatomic, weak) id<SKLocationDelegate> delegate;

+ (instancetype)shareManager;

- (void)findCurrentLocation;

@end
