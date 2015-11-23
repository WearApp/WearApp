//
//  SKHeWeatherCondition.h
//  Wear
//
//  Created by 孙恺 on 15/7/28.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface SKHeWeatherCondition : MTLModel<MTLJSONSerializing>

//@property (nonatomic, retain) NSString *cityName;
//@property (nonatomic, retain) NSString *countryName;
//@property (nonatomic, retain) NSString *update;


@property (nonatomic, copy, readonly) NSString *status;

@property (nonatomic, copy, readonly) NSString *cityName;
@property (nonatomic, copy, readonly) NSString *countryName;
@property (nonatomic, strong, readonly) NSDate *updateTimeUTC;
@property (nonatomic, strong, readonly) NSDate *updateTimeLOC;

@property (nonatomic, copy, readonly) NSString *now_condition_chn;
@property (nonatomic, strong, readonly) NSNumber *now_feelTemperature_num;
@property (nonatomic, copy, readonly) NSString *now_humidity_str;
@property (nonatomic, strong, readonly) NSNumber *now_precipitation_num;
@property (nonatomic, strong, readonly) NSNumber *now_pressure_num;
@property (nonatomic, strong, readonly) NSNumber *now_temperature_num;
@property (nonatomic, strong, readonly) NSNumber *now_visibility_num;
@property (nonatomic, copy, readonly) NSString *now_windDirection_str;
@property (nonatomic, copy, readonly) NSString *now_windLevel_str;
@property (nonatomic, strong, readonly) NSNumber *now_windSpeed_num;

@property (nonatomic, strong, readonly) NSNumber *aqi_aqi_num;
@property (nonatomic, strong, readonly) NSNumber *aqi_co_num;
@property (nonatomic, strong, readonly) NSNumber *aqi_no2_num;
@property (nonatomic, strong, readonly) NSNumber *aqi_o3_num;
@property (nonatomic, strong, readonly) NSNumber *aqi_so2_num;
@property (nonatomic, strong, readonly) NSNumber *aqi_pm10_num;
@property (nonatomic, strong, readonly) NSNumber *aqi_pm25_num;
@property (nonatomic, copy, readonly) NSString *aqi_aqi_str;

// type error
//@property (nonatomic, strong, readonly) NSArray *templow_daily_array;
//@property (nonatomic, strong, readonly) NSArray *temphi_daily_array;
//@property (nonatomic, strong, readonly) NSArray *condition_day_daily_array;
//@property (nonatomic, strong, readonly) NSArray *condition_night_daily_array;
//@property (nonatomic, strong, readonly) NSArray *windDirection_daily_array;
//@property (nonatomic, strong, readonly) NSArray *windLevel_daily_array;
//@property (nonatomic, strong, readonly) NSArray *pop_daily_array;
//@property (nonatomic, strong, readonly) NSArray *humidity_daily_array;
//
//@property (nonatomic, strong, readonly) NSNumber *temperature_hourly_num;
//@property (nonatomic, strong, readonly) NSNumber *pop_hourly_num;
//@property (nonatomic, strong, readonly) NSNumber *humidity_hourly_num;

@property (nonatomic, copy, readonly) NSString *suggestion_comfortable_str;
@property (nonatomic, copy, readonly) NSString *suggestion_cleanCar_str;
@property (nonatomic, copy, readonly) NSString *suggestion_wear_str;
@property (nonatomic, copy, readonly) NSString *suggestion_flu_str;
@property (nonatomic, copy, readonly) NSString *suggestion_sport_str;
@property (nonatomic, copy, readonly) NSString *suggestion_travel_str;
@property (nonatomic, copy, readonly) NSString *suggestion_uv_str;

@property (nonatomic, strong, readonly) NSArray *sevenday;

@end
