//
//  NSString+CategoryExtension.m
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "NSString+CategoryExtension.h"

@implementation NSString (CategoryExtension)

- (BOOL)isBlankString{
    if (self == NULL || [self isEqual:nil] || [self isEqual:Nil] || self == nil)
        return  YES;
    if ([self isEqual:[NSNull null]])
        return  YES;
    if (![self isKindOfClass:[NSString class]] )
        return  YES;
    if (0 == [self length] || 0 == [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
        return  YES;
    if([self isEqualToString:@"(null)"])
        return  YES;
    if([self isEqualToString:@"<null>"])
        return  YES;
    return NO;
}

@end
