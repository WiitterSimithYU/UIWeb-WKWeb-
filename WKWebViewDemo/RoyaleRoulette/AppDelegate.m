//
//  AppDelegate.m
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "AppDelegate.h"
#import "RoyaleNavigationViewController.h"
#import "RoyaleRootViewController.h"
#import "AppDelegate+Extension.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isFirstLoad = YES;
    [self startNetworkMonitoring];
    
    RoyaleRootViewController *rootViewController = [[RoyaleRootViewController alloc] init];
    rootViewController.urlString = @"http://6699805.com/test.html";
    RoyaleNavigationViewController *nav = [[RoyaleNavigationViewController alloc] initWithRootViewController:rootViewController];
    nav.orientationMask = UIInterfaceOrientationMaskAll;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)startNetworkMonitoring{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    self.networkStatus = manager.networkReachabilityStatus;
    [manager startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingStatusDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)networkingStatusDidChanged:(NSNotification*)info{
    NSDictionary *inforDict = [info userInfo];
    NSString *statusStr = [NSObject getStringFromDict:inforDict withKey:AFNetworkingReachabilityNotificationStatusItem];
    if (statusStr == nil || [statusStr isBlankString]) {
        statusStr = [NSObject getStringFromDict:inforDict withKey:@"LCNetworkingReachabilityNotificationStatusItem"];
    }
    
    NSInteger status   = [statusStr integerValue];
    
    if (status != AFNetworkReachabilityStatusNotReachable) {
        //        [self getSystemConfig];
    }
    
    if (self.isFirstLoad == YES) {
        self.isFirstLoad = NO;
        self.networkStatus = status;
        return;
    }
    
    if (status == self.networkStatus) {
        return;
    }
    
    self.networkStatus = status;
    if (status != AFNetworkReachabilityStatusNotReachable && status != AFNetworkReachabilityStatusUnknown) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            [AppDelegate show3GNetworkAlert];
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            [AppDelegate showWifiNetworkAlert];
        }else{
            [AppDelegate showOtherNetworkAlert];
        }
    }else{
        [AppDelegate showNoNetworkAlert];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
