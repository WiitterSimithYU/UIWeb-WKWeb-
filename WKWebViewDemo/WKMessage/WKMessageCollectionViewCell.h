//
//  WKMessageCollectionViewCell.h
//  WKMessage
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKMessageModel.h"

@interface WKMessageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)WKMessageModel *assistModel;

@property (nonatomic,strong,readonly) UIImage *cellImage;

@end
