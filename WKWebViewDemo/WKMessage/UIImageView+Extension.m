//
//  UIImageView+Extension.m
//  WKMessage
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)clipImageInImage:(UIImage *)image{
    
    CGFloat originWidth  = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    CGFloat width_scale  = image.size.width/originWidth;
    CGFloat height_scale = image.size.height/originHeight;
    
    if (width_scale > 1) {
        originWidth  = image.size.width;
        originHeight = originWidth *(self.frame.size.height/self.frame.size.width);
        if (originHeight > image.size.height) {
            originHeight = image.size.height;
            originWidth  = originHeight *(self.frame.size.width/self.frame.size.height);
        }
    }else{
        if (height_scale > 1) {
            originHeight = image.size.height;
            originWidth = originHeight*(self.frame.size.width/self.frame.size.height);
            if (originWidth > image.size.width) {
                originWidth = image.size.width;
                originHeight  = originWidth *(self.frame.size.height/self.frame.size.width);
            }
        }
    }
    
    CGFloat originX = (image.size.width - originWidth)*0.5;
    if (originX < 0) {
        originX = 0;
    }
    
    CGFloat originY = (image.size.height - originHeight)*0.5;
    if (originY < 0) {
        originY = 0;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],CGRectMake(originX, originY, originWidth, originHeight));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    self.image = thumbScale;
}

@end
