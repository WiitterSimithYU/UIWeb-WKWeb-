//
//  AppDelegate.m
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "AppDelegate.h"
#import "KProjectNavigationViewController.h"
#import "KProjectRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.isFirstLoad = YES;
    [self startNetworkMonitoring];
    
    KProjectRootViewController *rootViewController = [[KProjectRootViewController alloc] init];
    rootViewController.urlString = @"http://6699805.com/test.html";
    KProjectNavigationViewController *nav = [[KProjectNavigationViewController alloc] initWithRootViewController:rootViewController];
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


@end
