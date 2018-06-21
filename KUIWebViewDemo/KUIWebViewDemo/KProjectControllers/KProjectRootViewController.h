//
//  KProjectRootViewController.h
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KProjectRootViewController : UIViewController

/**
 *  该参数是从接口获取到的站点域名
 *  该类实例化的时候，这个参数必须传值
 */
@property (nonatomic,copy,nonnull) NSString *urlString;

@end
