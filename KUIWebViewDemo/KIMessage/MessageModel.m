//
//  MessageModel.m
//  KIMessage
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel



- (id)initWithDictionary:(NSDictionary*)object{
    self = [super init];
    if (self) {
        [self setPropertyWithObject:object];
    }
    return self;
}

- (void)setPropertyWithObject:(NSDictionary*)object{
    self.imessageImageURL = [self getValueFromDictionary:object key:@"imessageImageURL"];
    self.imessageTitle    = [self getValueFromDictionary:object key:@"imessageTitle"];
    self.imessageURL      = [self getValueFromDictionary:object key:@"imessageURL"];
    
    NSLog(@"self.imessageImageURL ========== %@",self.imessageImageURL);
}

- (NSString*)getValueFromDictionary:(NSDictionary*)object key:(id)key{
    NSString *string = [NSString stringWithFormat:@"%@",[object objectForKey:key]];;
    if ([self isBlankString:string]) {
        string = @"";
    }
    return string;
}

- (BOOL)isBlankString:(NSString*)string{
    if (string == NULL || [string isEqual:nil] || [string isEqual:Nil] || string == nil)
        return  YES;
    if ([string isEqual:[NSNull null]])
        return  YES;
    if (![string isKindOfClass:[NSString class]] )
        return  YES;
    if (0 == [string length] || 0 == [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
        return  YES;
    if([string isEqualToString:@"(null)"])
        return  YES;
    if([string isEqualToString:@"<null>"])
        return  YES;
    
    return NO;
}

@end
