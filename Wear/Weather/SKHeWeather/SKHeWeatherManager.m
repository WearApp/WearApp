//
//  SKHeWeatherManager.m
//  Wear
//
//  Created by 孙恺 on 15/7/28.
//  Copyright (c) 2015年 Kai Sun. All rights reserved.
//

#import "SKHeWeatherManager.h"
#import "SKHeWear.h"

@implementation SKHeWeatherManager

#pragma mark - Public Methods
- (void)refreshConditionWithCityName:(NSString *)cityName {
    [self buildURLWithCityName:cityName];
}

- (void)refreshConditionWithCurrentLocation {
    _location = [SKLocation shareManager];
    [_location findCurrentLocation];
    [_location addObserver:self forKeyPath:@"city" options:0 context:nil];
}

#pragma mark - Private Methods

- (NSString *)engCityNameWithChnCityName:(NSString *)chnCityName {
    NSMutableString *engCityName = [[NSMutableString alloc] initWithString:_location.city];
    NSMutableString *str = [[NSMutableString alloc] init];
    if ([_location.district isEqualToString:@"神农架林区"]) {
        return @"shennongjia";
    }else if ([_location.district isEqualToString:@"格尔木市"]) {
        return @"geermu";
    }
    if ([_location.city isEqualToString:@"齐齐哈尔市"]||[_location.city isEqualToString:@"大兴安岭地区"]||
        [_location.city isEqualToString:@"呼和浩特市"]||[_location.city isEqualToString:@"乌兰察布市"]||
        [_location.city isEqualToString:@"鄂尔多斯市"]||[_location.city isEqualToString:@"巴彦淖尔市"]||
        [_location.city isEqualToString:@"锡林郭勒盟"]||[_location.city isEqualToString:@"呼伦贝尔市"]||
        [_location.city isEqualToString:@"阿拉善盟"]||[_location.city isEqualToString:@"乌鲁木齐市"]||
        [_location.city isEqualToString:@"克拉玛依市"]||[_location.city isEqualToString:@"巴音郭楞州"]||
        [_location.city isEqualToString:@"博尔塔拉州"]||[_location.city isEqualToString:@"西双版纳州"]) {
        str = [NSMutableString stringWithString:[engCityName substringToIndex:4]];
    }
    else if ([_location.city isEqualToString:@"哈尔滨市"]||[_location.city isEqualToString:@"牡丹江市"]||
              [_location.city isEqualToString:@"佳木斯市"]||[_location.city isEqualToString:@"七台河市"]||
              [_location.city isEqualToString:@"双鸭山市"]||[_location.city isEqualToString:@"葫芦岛市"]||
              [_location.city isEqualToString:@"兴安盟"]||[_location.city isEqualToString:@"石家庄市"]||
              [_location.city isEqualToString:@"张家口市"]||[_location.city isEqualToString:@"秦皇岛市"]||
              [_location.city isEqualToString:@"石河子市"]||[_location.city isEqualToString:@"吐鲁番地区"]||
              [_location.city isEqualToString:@"阿勒泰地区"]||[_location.city isEqualToString:@"日喀则地区"]||
              [_location.city isEqualToString:@"嘉峪关市"]||[_location.city isEqualToString:@"连云港市"]||
              [_location.city isEqualToString:@"石嘴山市"]||[_location.city isEqualToString:@"平顶山市"]||
              [_location.city isEqualToString:@"驻马店市"]||[_location.city isEqualToString:@"三门峡市"]||
              [_location.city isEqualToString:@"马鞍山市"]||[_location.city isEqualToString:@"钓鱼岛"]||
              [_location.city isEqualToString:@"景德镇市"]||[_location.city isEqualToString:@"张家界市"]||
              [_location.city isEqualToString:@"黔东南苗族侗族自治州"]||[_location.city isEqualToString:@"六盘水市"]||
              [_location.city isEqualToString:@"黔西南布依族苗族自治州"]||[_location.city isEqualToString:@"攀枝花市"]||
              [_location.city isEqualToString:@"防城港市"]||[_location.city isEqualToString:@"五指山市"]) {
              str = [NSMutableString stringWithString:[engCityName substringToIndex:3]];
    }
    else {
        str = [NSMutableString stringWithString:[engCityName substringToIndex:2]];
    }
    
    if (CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformMandarinLatin, NO)) {
        NSLog(@"%@",str);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"%@",str);
    }
    // 去除空格
    for (int i=0; i<str.length; ++i) {
        if ([str characterAtIndex:i]==' ') {
            [str deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    return str;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%@",keyPath);
    if ([keyPath isEqualToString:@"city"]) {
        if (_location.city) {
            [_location removeObserver:self forKeyPath:@"city"];
            NSString *engCityName = [self engCityNameWithChnCityName:_location.city];
            NSLog(@"%@",engCityName);
            [self buildURLWithCityName:engCityName];
            NSLog(@"stop kvo");
        }
    }
}

#pragma mark - HeWeahter API
- (void)buildURLWithCityName:(NSString *)cityName {
    NSString *httpURL = @"http://apis.baidu.com/heweather/weather/free";
    NSString *httpArg = [NSString stringWithFormat:@"city=%@",cityName];
    [self request:httpURL withHttpArg:httpArg];
}

- (void)request:(NSString *)httpURL withHttpArg:(NSString *)httpArg {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@?%@",httpURL,httpArg];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"fb9e5e49354669b62934dd0ef59275ac" forHTTPHeaderField:@"apikey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error) {
            NSLog(@"httpError:%ld,%@",(long)error.code,error.localizedDescription);
        }else {
            
            NSMutableData *mutableData = [[NSMutableData alloc] initWithData:data];
            [mutableData replaceBytesInRange:NSMakeRange(2, 26) withBytes:"condition" length:9];
            
            [mutableData replaceBytesInRange:NSMakeRange(13, 1) withBytes:NULL length:0];
            [mutableData replaceBytesInRange:NSMakeRange([mutableData length]-2, 1) withBytes:NULL length:0];
            
//            NSString *s = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",s);
            
            NSDictionary *forecastDictionary = [NSJSONSerialization JSONObjectWithData:mutableData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",forecastDictionary);
            
            //            NSLog(@"ResponseCode:%ld",(long)responseCode);
            //            NSLog(@"ResponseBody:%@",responseString);
            
            NSError *error = [[NSError alloc] init];
            self.weatherCondition = [MTLJSONAdapter modelOfClass:SKHeWeatherCondition.class fromJSONDictionary:forecastDictionary error:&error];
            if (error!=nil) {
                NSLog(@"error:%@",error.localizedDescription);
            } else {
                // output result
                NSLog(@"status:%@",self.weatherCondition.status);
                NSLog(@"%@%@\n %@%@",self.weatherCondition.countryName,self.weatherCondition.cityName,self.weatherCondition.updateTimeUTC,self.weatherCondition.updateTimeLOC);
                NSLog(@"nowCondition:%@",self.weatherCondition.now_condition_chn);
                NSLog(@"fellTemperature:%@",self.weatherCondition.now_feelTemperature_num);
                NSLog(@"windSpeed:%@",self.weatherCondition.now_windSpeed_num);
                for (int i=0; i<7; i++) {
                    NSLog(@"%i: %@ %@℃-%@℃",i+1,self.weatherCondition.sevenday[i][@"cond"][@"txt_n"],self.weatherCondition.sevenday[i][@"tmp"][@"min"],self.weatherCondition.sevenday[i][@"tmp"][@"max"]);
                }
                SKHeWear *wear = [[SKHeWear alloc] initWithSingleDayWeatherCondition:self.weatherCondition.sevenday[0]]; // 七天
//                SKHeWear *wear = [[SKHeWear alloc] initWithCurrentWeatherCondition:self.weatherCondition];                        // 当天
                NSLog(@"%@",wear.wear);
                
                // TODO: notify fresh UI
            }
        }
    }];
}

@end
