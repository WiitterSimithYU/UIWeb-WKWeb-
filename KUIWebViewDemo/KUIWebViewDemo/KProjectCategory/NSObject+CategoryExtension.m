//
//  NSObject+CategoryExtension.m
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "NSObject+CategoryExtension.h"

@implementation NSObject (CategoryExtension)

+(BOOL)isOrientationPortrait{
    UIInterfaceOrientation interface = [UIApplication sharedApplication].statusBarOrientation;
    if (interface == UIInterfaceOrientationLandscapeLeft || interface == UIInterfaceOrientationLandscapeRight) {// 横屏
        return NO;
    }
    
    return YES;
}

+ (NSString *)getStringFromDict:(NSDictionary*)dict withKey:(id)key{
    
    NSString *string = @"";
    if (dict && [dict objectForKey:key]) {
        string = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
    }
    
    if (string == nil || [string isBlankString]) {
        string = @"";
    }
    
    return string;
}

@end
