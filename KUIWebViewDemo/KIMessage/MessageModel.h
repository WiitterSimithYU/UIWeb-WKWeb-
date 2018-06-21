//
//  MessageModel.h
//  KIMessage
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,copy  ) NSString *imessageImageURL;
@property (nonatomic,copy  ) NSString *imessageTitle;
@property (nonatomic,copy  ) NSString *imessageURL;

- (id)initWithDictionary:(NSDictionary*)object;

@end
