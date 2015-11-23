//
//  SKHeWeatherCondition.m
//  Wear
//
//  Created by 孙恺 on 15/7/28.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import "SKHeWeatherCondition.h"

@implementation SKHeWeatherCondition

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) {
        return nil;
    }
    _updateTimeUTC = [NSDate date];
    _updateTimeLOC = [NSDate date];
    _updateTimeLOC = [self convertDateToLocalTime:_updateTimeLOC];
    return self;
}

- (NSDate *)convertDateToLocalTime: (NSDate *)forDate {
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    int timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];
    return newDate;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             // status
             @"status" : @"condition.status",
             // basic
             @"cityName" : @"condition.basic.city",
             @"countryName" : @"condition.basic.cnty",
             @"updateTimeUTC" : @"condition.basic.update.utc",
             @"updateTimeLOC" : @"condition.basic.update.loc",
             // now
             @"now_condition_chn" : @"condition.now.cond.txt",
             @"now_feelTemperature_num" : @"condition.now.fl",
             @"now_humidity_str" : @"condition.now.hum",
             @"now_precipitation_num" : @"condition.now.pcpn",
             @"now_pressure_num" : @"condition.now.pres",
             @"now_temperature_num" : @"condition.now.tmp",
             @"now_visibility_num" : @"condition.now.vis",
             @"now_windDirection_str" : @"condition.now.wind.dir",
             @"now_windLevel_str" : @"condition.now.wind.sc",
             @"now_windSpeed_num" : @"condition.now.wind.spd",
             // aqi
             @"aqi_aqi_num" : @"condition.aqi.city.aqi",
             @"aqi_co_num" : @"condition.aqi.city.co",
             @"aqi_no2_num" : @"condition.aqi.city.no2",
             @"aqi_o3_num" : @"condition.aqi.city.o3",
             @"aqi_so2_num" : @"condition.aqi.city.so2",
             @"aqi_pm10_num" : @"condition.aqi.city.pm10",
             @"aqi_pm25_num" : @"condition.aqi.city.pm25",
             @"aqi_aqi_str" : @"condition.aqi.city.qlty",
             // type error
//             // daily_forecast
//             @"templow_daily_array" : @"condition.daily_forecast.tmp.min",
//             @"temphi_daily_array" : @"condition.daily_forecast.tmp.max",
//             @"condition_day_daily_array" : @"condition.daily_forecast.cond.txt_d",
//             @"condition_night_daily_array" : @"condition.daily_forecast.cond.txt_n",
//             @"windDirection_daily_array" : @"condition.daily_forecast.wind.dir",
//             @"windLevel_daily_array" : @"condition.daily_forecast.wind.sc",
//             @"pop_daily_array" : @"condition.daily_forecast.pop",
//             @"humidity_daily_array" : @"condition.daily_forecast.hum",
//             // hourly_forecast
//             @"temperature_hourly_num" : @"condition.hourly_forecast.tmp",
//             @"pop_hourly_num" : @"condition.hourly_forecast.pop",
//             @"humidity_hourly_num" : @"condition.hourly_forecast.hum",
             // suggestion
             @"suggestion_comfortable_str" : @"condition.suggestion.comf.brf",
             @"suggestion_cleanCar_str" : @"condition.suggestion.cw.brf",
             @"suggestion_wear_str" : @"condition.suggestion.drsg.brf",
             @"suggestion_flu_str" : @"condition.suggestion.flu.brf",
             @"suggestion_sport_str" : @"condition.suggestion.sport.brf",
             @"suggestion_travel_str" : @"condition.suggestion.trav.brf",
             @"suggestion_uv_str" : @"condition.suggestion.uv.brf",
             
             @"sevenday" : @"condition.daily_forecast"
             };
}

@end
