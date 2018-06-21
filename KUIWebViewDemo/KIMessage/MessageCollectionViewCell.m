//
//  MessageCollectionViewCell.m
//  KIMessage
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "MessageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#define kMainScreenWith      ([UIScreen mainScreen].bounds.size.width)
#define kMainScreenHeight    ([UIScreen mainScreen].bounds.size.height)

@interface MessageCollectionViewCell ()
{
    UIActivityIndicatorView *kIndicatorView;
    UIImageView *kImageView;
}
@end

@implementation MessageCollectionViewCell

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
    [kImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:kImageView];
    
    kIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [kIndicatorView setHidesWhenStopped:YES];
    [kImageView addSubview:kIndicatorView];
    kIndicatorView.center = CGPointMake(kImageView.frame.size.width*0.5, kImageView.frame.size.height*0.5);
}

- (void)setMsgModel:(MessageModel *)msgModel{
    _msgModel = msgModel;
    NSString *imageURL = _msgModel.imessageImageURL;
    [kIndicatorView startAnimating];
    [kImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                  placeholderImage:nil
                           options:SDWebImageContinueInBackground
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self->kIndicatorView stopAnimating];
                             });
                         }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    kImageView.frame = self.bounds;
    kIndicatorView.center = CGPointMake(kImageView.frame.size.width*0.5, kImageView.frame.size.height*0.5);
}

- (UIImage*)cellImage{
    return kImageView.image;
}

@end
