//
//  KProjectBottomOperationView.h
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,KProjectBottomOperationStyle) {
    KProjectBottomOperationStyleGoBack = 1000,
    KProjectBottomOperationStyleGoForward,
    KProjectBottomOperationStyleRefresh,
    KProjectBottomOperationStyleHomePage,
    KProjectBottomOperationStyleMenu
};

@protocol KProjectBottomOperationViewDelegate <NSObject>

@optional

- (void)performOperationWithStyle:(KProjectBottomOperationStyle)style;

@end

@interface KProjectBottomOperationView : UIView

@property (nonatomic,assign) id<KProjectBottomOperationViewDelegate>delegate;

@end
