//
//  AppDelegate.h
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) BOOL isFirstLoad;

@property (nonatomic,assign) AFNetworkReachabilityStatus networkStatus;

@end

