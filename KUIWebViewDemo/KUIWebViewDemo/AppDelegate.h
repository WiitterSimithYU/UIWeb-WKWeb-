//
//  AppDelegate.h
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AFNetworking;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) BOOL isFirstLoad;

@property (nonatomic,assign) AFNetworkReachabilityStatus networkStatus;

@end

