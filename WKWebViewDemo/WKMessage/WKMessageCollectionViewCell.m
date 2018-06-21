//
//  WKMessageCollectionViewCell.m
//  WKMessage
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "WKMessageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Extension.h"

#define kMainScreenWith      ([UIScreen mainScreen].bounds.size.width)
#define kMainScreenHeight    ([UIScreen mainScreen].bounds.size.height)

@interface WKMessageCollectionViewCell ()
{
    UIImage *downloadImage;
    UIImageView *kImageView;
    
    UIActivityIndicatorView *kIndicatorView;
}
@end

@implementation WKMessageCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    kImageView = [[UIImageView alloc] init];
    kImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:kImageView];
    
    kIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [kIndicatorView setHidesWhenStopped:YES];
    [kImageView addSubview:kIndicatorView];
    
    kIndicatorView.center = CGPointMake(kImageView.frame.size.width*0.5, kImageView.frame.size.height*0.5);
}

- (void)setAssistModel:(WKMessageModel *)assistModel{
    _assistModel = assistModel;
    NSString *imageURL = _assistModel.imessageImageURL;
    [kIndicatorView startAnimating];
    [kImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                  placeholderImage:nil
                           options:SDWebImageContinueInBackground
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             [kIndicatorView stopAnimating];
                             if (image) {
                                 downloadImage = image;
                                 [kImageView clipImageInImage:image];
                             }
                         }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    kImageView.frame = self.bounds;
    kIndicatorView.center = CGPointMake(kImageView.frame.size.width*0.5, kImageView.frame.size.height*0.5);
    
//    if (kMainScreenWith < kMainScreenHeight) {
//        kImageView.frame = self.bounds;
//    }else{
//        if (self.cellImage != nil) {
//            CGFloat height = self.frame.size.height;
//            CGFloat width  = height*(self.cellImage.size.width/self.cellImage.size.height);
//            kImageView.frame = CGRectMake(0, 0, width, height);
//            kImageView.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
//        }else{
//            kImageView.frame = self.bounds;
//        }
//    }
}

- (UIImage*)cellImage{
    return downloadImage;
}

@end
