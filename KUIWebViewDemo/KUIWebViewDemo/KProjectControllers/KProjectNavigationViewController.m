//
//  KProjectNavigationViewController.m
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "KProjectNavigationViewController.h"

@interface KProjectNavigationViewController ()

@end

@implementation KProjectNavigationViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.orientationMask = UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.orientationMask;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
