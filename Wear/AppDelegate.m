//
//  AppDelegate.m
//  Wear
//
//  Created by 孙恺 on 15/10/11.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "CommonMarco.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "ViewController.h"

#import <Bugly/CrashReporter.h>

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate

#pragma mark - Background Fetch Callback

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    ViewController *mainVC = (ViewController *)self.window.rootViewController;
    
    NSLog(@"applicationperformfetchwithcompletion");
    
    if ([mainVC isKindOfClass:[ViewController class]]) {
        [(ViewController *)mainVC insertNewObjectForFetchWithCompletionHandler:completionHandler];
    } else {
        NSLog(@"Not the right class %@.", [ViewController class]);
        completionHandler(UIBackgroundFetchResultFailed);
    }
}

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:7200];
    
    [[CrashReporter sharedInstance] installWithAppId:@"900013005"];
    
    // Override point for customization after application launch.
    [self init3rdShare];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor redColor]];
    
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    [self.window setRootViewController:vc];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        return [TencentOAuth HandleOpenURL:url];
        
    }else if([[url absoluteString] hasPrefix:@"wb"]){
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}


/**
 *  初始化第三方组件
 */
- (void)init3rdShare
{
    [WXApi registerApp:APP_KEY_WEIXIN];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:APP_KEY_WEIBO];
    
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
