//
//  NSObject+CategoryExtension.h
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CategoryExtension)

+(BOOL)isOrientationPortrait;

+ (NSString *)getStringFromDict:(NSDictionary*)dict withKey:(id)key;

@end
