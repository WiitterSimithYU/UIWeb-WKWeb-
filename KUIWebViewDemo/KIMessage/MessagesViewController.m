//
//  MessagesViewController.m
//  KIMessage
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageCollectionViewCell.h"

#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)

#define CellHeight  120
#define CellWidth ((KScreenWidth-7.5)*0.5)

static NSString *CollectionIdentifier = @"MessageControllerViewCellIdentifier";

@interface MessagesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *kCollectionView;
    NSMutableArray *dataSource;
    UICollectionViewFlowLayout *kCollectionViewFlowLayout;
}
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSource = [[NSMutableArray alloc] init];
    
    CGFloat width  = CellWidth;
    CGFloat height = width*(480.0f/800.0f);
    
    kCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    kCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    kCollectionViewFlowLayout.minimumLineSpacing = 5;
    kCollectionViewFlowLayout.minimumInteritemSpacing = 2.5;
    kCollectionViewFlowLayout.itemSize = CGSizeMake(width, height);
    kCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 0, 2);
    
    kCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) collectionViewLayout:kCollectionViewFlowLayout];
    
    kCollectionView.backgroundColor = [UIColor whiteColor];
    kCollectionView.dataSource = self;
    kCollectionView.delegate = self;
    [kCollectionView registerClass:[MessageCollectionViewCell class] forCellWithReuseIdentifier:CollectionIdentifier];
    [self.view addSubview:kCollectionView];
    
    if (@available(iOS 11,*)) {
        kCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionIdentifier forIndexPath:indexPath];
    cell.msgModel = [dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSMessageTemplateLayout *layout = [[MSMessageTemplateLayout alloc] init];
    
    MessageCollectionViewCell *cell = (MessageCollectionViewCell*)[kCollectionView cellForItemAtIndexPath:indexPath];
    MessageModel *model = [dataSource objectAtIndex:indexPath.row];
    if (cell != nil && cell.cellImage != nil) {
        layout.image = cell.cellImage;
    }else{
        layout.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imessageImageURL]]];
    }
    
    layout.caption = model.imessageTitle;
    layout.subcaption = @"点击查看详情";
    
    MSMessage *message = [[MSMessage alloc] init];
    message.URL = [NSURL URLWithString:model.imessageURL];
    message.layout = layout;
    
    [self.activeConversation insertMessage:message completionHandler:^(NSError * _Nullable Handle) {
        if (Handle) {
            NSLog(@"%@",Handle);
        }
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat width  = (self.view.frame.size.width-7.5)*0.5;
    CGFloat height = 0.5*width;
    kCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 0, 2);
    kCollectionViewFlowLayout.minimumLineSpacing = 5;
    kCollectionViewFlowLayout.minimumInteritemSpacing = 2.5;
    kCollectionViewFlowLayout.itemSize = CGSizeMake(width, height);
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat screenWidth  = frame.size.width;
    CGFloat screenHeight = frame.size.height;
    
    CGFloat originY = 0;
    if (version < 11.0) {
        if (CGRectEqualToRect(self.view.bounds, frame)) {// 全屏显示
            if (screenWidth < screenHeight) {// 竖屏
                originY = 86;
            }else{
                originY = 67;
            }
        }
    }
    kCollectionView.frame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - 44 - originY);
}

- (void)initialData{
    if (dataSource.count < 1) {
#warning ------- 测试数据，打包上架时，改成线上数据
#warning ------- 测试数据，打包上架时，改成线上数据
#warning ------- 测试数据，打包上架时，改成线上数据
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
            MessageModel *model = [[MessageModel alloc] initWithDictionary:dict];
            [dataSource addObject:model];
        }
        
        [kCollectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.
    
    if (dataSource.count < 1) {
        [self initialData];
    }
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
