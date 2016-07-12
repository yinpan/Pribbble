//
//  AppDelegate.m
//  iDesign
//
//  Created by 千锋 on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//
//  添加git代码托管测试信息

#import "AppDelegate.h"
#import "YPTabBarViewController.h"
#import "YPWelcomeViewController.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


#pragma mark -- 懒加载Client
- (YPApiClient *)client
{
    
    if (!_client) {
        DRApiClientSettings *settings = [[DRApiClientSettings alloc]
                                         initWithBaseUrl:OAuth2_BASE_URL
                                         oAuth2RedirectUrl:OAuth2_RedirectUrl
                                         oAuth2AuthorizationUrl:OAuth2_AuthorizationUrl
                                         oAuth2TokenUrl:OAuth2_TokenUrl
                                         clientId:OAuth2_CLIENT_ID
                                         clientSecret:OAuth2_CLIENT_SECRET
                                         clientAccessToken:OAuth2_CLIENT_ACCESS_TOKEN
                                         scopes:OAuth2_DRIBBBLE_SCOPES];
        _client = [[YPApiClient alloc] initWithSettings:settings];
    }
    return _client;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];

    _window.rootViewController = [[YPTabBarViewController alloc] init];
    
    [_window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSLog(@"%@",NSHomeDirectory());
    return YES;
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
