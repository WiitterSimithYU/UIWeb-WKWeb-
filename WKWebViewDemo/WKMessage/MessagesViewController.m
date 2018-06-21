//
//  MessagesViewController.m
//  WKMessage
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "MessagesViewController.h"
#import "WKMessageModel.h"
#import "WKMessageViewController.h"


@interface MessagesViewController ()
{
    NSMutableArray *dataSource;
    
    WKMessageViewController *assistController;
    
    UIInterfaceOrientation kOrientation;
    
    NSString *selectedURL;
}
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (dataSource == nil) {
        dataSource = [[NSMutableArray alloc] init];
    }
    
    if (assistController == nil) {
        assistController = [[WKMessageViewController alloc] init];
        assistController.mvc = self;
        [assistController viewDidLoad];
        [self addChildViewController:assistController];
        [self.view addSubview:assistController.view];
    }
    
    [self.view.topAnchor    constraintEqualToAnchor:assistController.view.topAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:assistController.view.bottomAnchor].active = YES;
    [self.view.leftAnchor   constraintEqualToAnchor:assistController.view.leftAnchor].active = YES;
    [self.view.rightAnchor  constraintEqualToAnchor:assistController.view.rightAnchor].active = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBardidChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    kOrientation = UIInterfaceOrientationPortrait;
    
    [self initialData];
}

- (void)initialData{
    if (dataSource.count < 1) {
        
        NSString *imageURL1 = @"http://lc-vmk3injq.cn-n1.lcfile.com/75a4789e608a57461c7f.jpg";
        NSString *imageURL2 = @"http://lc-vmk3injq.cn-n1.lcfile.com/543f9bda571337c86ebe.jpg";
        NSString *imageURL3 = @"http://lc-vmk3injq.cn-n1.lcfile.com/be49399c857b5a6ebbec.jpg";
        NSString *imageURL4 = @"http://lc-vmk3injq.cn-n1.lcfile.com/95a442b9f0359a10562e.jpg";
        NSString *imageURL5 = @"http://lc-vmk3injq.cn-n1.lcfile.com/95a442b9f0359a10562e.jpg";
        NSString *imageURL6 = @"http://lc-vmk3injq.cn-n1.lcfile.com/60c5c501981dac9bdbcc.jpg";
        NSString *imageURL7 = @"http://lc-vmk3injq.cn-n1.lcfile.com/7ccb18bf10f5a75194a4.jpg";
        NSString *imageURL8 = @"http://lc-vmk3injq.cn-n1.lcfile.com/7dd8bc441f0a9f382058.jpg";
        NSArray *arr = @[@{@"imessageImageURL":imageURL1,@"imessageTitle":@"范冰冰",@"imessageURL":@"https://www.baidu.com"},
                         @{@"imessageImageURL":imageURL2,@"imessageTitle":@"苍老师",@"imessageURL":@"https://www.baidu.com"},
                         @{@"imessageImageURL":imageURL3,@"imessageTitle":@"唐嫣",@"imessageURL":@"https://www.baidu.com"},
                         @{@"imessageImageURL":imageURL4,@"imessageTitle":@"柳岩",@"imessageURL":@"https://www.baidu.com"},
                         @{@"imessageImageURL":imageURL5,@"imessageTitle":@"小泽玛利亚",@"imessageURL":@"https://www.baidu.com"},
                         @{@"imessageImageURL":imageURL6,@"imessageTitle":@"范玮琪",@"imessageURL":@"https://www.baidu.com"},
                         @{@"imessageImageURL":imageURL7,@"imessageTitle":@"梁静茹",@"imessageURL":@"https://www.baidu.com"},
                         @{@"imessageImageURL":imageURL8,@"imessageTitle":@"李宇春",@"imessageURL":@"https://www.baidu.com"}];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dict = [arr objectAtIndex:i];
            WKMessageModel *model = [[WKMessageModel alloc] initWithDictionary:dict];
            [dataSource addObject:model];
        }
        
        assistController.dataSource = dataSource;
        [assistController reloadCollectionView];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    assistController.view.frame = self.view.bounds;
    assistController.applicationOrientation = kOrientation;
}

- (void)statusBardidChanged:(NSNotification*)info{
    NSDictionary *dict = [info userInfo];
    if (dict) {
        NSNumber *number = [dict objectForKey:UIApplicationStatusBarOrientationUserInfoKey];
        UIInterfaceOrientation orientation = [number integerValue];
        kOrientation = orientation;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    
    if (dataSource.count < 1) {
        [self initialData];
    }
    
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called before the extension transitions to a new presentation style.
    
    // Use this method to prepare for the change in presentation style.
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
}

@end
