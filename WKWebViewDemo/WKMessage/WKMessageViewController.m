//
//  WKMessageViewController.m
//  WKMessage
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "WKMessageViewController.h"
#import "WKMessageCollectionViewCell.h"

#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)

#warning ----- 根据要求可做修改
#warning ----- 根据要求可做修改
#warning ----- 根据要求可做修改
#define CellHeight  120
#define CellWidth ((KScreenWidth-7.5)*0.5)

static NSString *CollectionIdentifier = @"MessageControllerViewCellIdentifier";

@interface WKMessageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionViewFlowLayout *kCollectionViewFlowLayout;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WKMessageViewController

- (id)init{
    self = [super init];
    if (self) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width  = CellWidth;
    CGFloat height = width*(240.0f/368.0f);
    
    kCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    kCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    kCollectionViewFlowLayout.minimumLineSpacing = 5;
    kCollectionViewFlowLayout.minimumInteritemSpacing = 2.5;
    kCollectionViewFlowLayout.itemSize = CGSizeMake(width, height);
    kCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 0, 2);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) collectionViewLayout:kCollectionViewFlowLayout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[WKMessageCollectionViewCell class] forCellWithReuseIdentifier:CollectionIdentifier];
    [self.view addSubview:self.collectionView];
    
    if (@available(iOS 11,*)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WKMessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionIdentifier forIndexPath:indexPath];
    cell.assistModel = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSMessageTemplateLayout *layout = [[MSMessageTemplateLayout alloc] init];
    
    WKMessageCollectionViewCell *cell = (WKMessageCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    WKMessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
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
    
    [self.mvc.activeConversation insertMessage:message completionHandler:^(NSError * _Nullable Handle) {
        if (Handle) {
            NSLog(@"%@",Handle);
        }
    }];
}

- (void)reloadCollectionView{
    [self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat kwdith  = frame.size.width;
    CGFloat kheight = frame.size.height;
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat originY = 0;
    if (version < 11.0) {
        if (CGRectEqualToRect(self.view.bounds, frame)) {// 全屏显示
            if (kwdith < kheight) {// 竖屏
                originY = 86;
            }else{
                originY = 67;
            }
        }
    }
    self.collectionView.frame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - 44 - originY);
    
    CGFloat width  = CellWidth;
    CGFloat height = width*(240.0f/368.0f);
    kCollectionViewFlowLayout.minimumLineSpacing = 5;
    kCollectionViewFlowLayout.minimumInteritemSpacing = 2.5;
    kCollectionViewFlowLayout.itemSize = CGSizeMake(width, height);
    kCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 0, 2);
}

- (void)setApplicationOrientation:(UIInterfaceOrientation)applicationOrientation{
    _applicationOrientation = applicationOrientation;
    
    kCollectionViewFlowLayout.itemSize = CGSizeMake(CellWidth, CellHeight);
    self.collectionView.collectionViewLayout = kCollectionViewFlowLayout;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
