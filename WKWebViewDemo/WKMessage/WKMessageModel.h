//
//  WKMessageModel.h
//  WKMessage
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKMessageModel : NSObject

@property (nonatomic,copy  ) NSString *imessageImageURL;
@property (nonatomic,copy  ) NSString *imessageTitle;
@property (nonatomic,copy  ) NSString *imessageURL;

- (id)initWithDictionary:(NSDictionary*)object;

@end
