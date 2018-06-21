//
//  WKMessageViewController.h
//  WKMessage
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesViewController.h"

@interface WKMessageViewController : UIViewController

@property (nonatomic, weak) MessagesViewController *mvc;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) UIInterfaceOrientation applicationOrientation;

- (void)reloadCollectionView;

@end
