//
//  SKAMapLocation.h
//  Wear
//
//  Created by 孙恺 on 15/7/15.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

@protocol SKAMapLocationDelegate <NSObject>

@optional

/*
 * @property (nonatomic, copy) NSString *province; //!< 省/直辖市
 @property (nonatomic, copy) NSString *city;     //!< 市
 @property (nonatomic, copy) NSString *district; //!< 区
 @property (nonatomic, copy) NSString *citycode; //!< 城市编码
 @property (nonatomic, copy) NSString *adcode;   //!< 区域编码
 */

- (void)didGetAccuracy:(CLLocationAccuracy)accuracy;
- (void)didGetLocalCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)didGetLocalAreaID:(NSString *)areaid cityCode:(NSString *)cityCode districtCode:(NSString *)districtCode;
- (void)didGetProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;
- (void)didGetAddress:(NSString *)formattedAddress;

- (void)didFailLocationWithError:(NSError *)error;

@end

@interface SKAMapLocation : NSObject

@property (nonatomic, weak) id<SKAMapLocationDelegate> delegate;

@property BOOL locatedSuccess;

+ (instancetype)shareManager;

- (void)findCurrentLocation;

@end
