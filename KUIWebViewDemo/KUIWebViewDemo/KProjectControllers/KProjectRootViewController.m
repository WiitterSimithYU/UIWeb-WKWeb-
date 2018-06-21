//
//  KProjectRootViewController.m
//  KUIWebViewDemo
//
//  Created by Yonger on 2018/5/5.
//  Copyright © 2018年 KUIWebViewDemo. All rights reserved.
//

#import "KProjectRootViewController.h"
#import "KProjectBottomOperationView.h"
#import "KProjectNetworkDisConnectedView.h"
#import "MBProgressHUD.h"

#define PROGRESS_HEIGHT     4.0f

@interface KProjectRootViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,KProjectBottomOperationViewDelegate>
{
    UIWebView *kUIWebView;
    BOOL isShowAlert;
    
    KProjectBottomOperationView *contentBottomView;
    AFNetworkReachabilityStatus networkStatus;
}

@property (nonatomic,strong) KProjectNetworkDisConnectedView *noNetworkAlertView;

@end

@implementation KProjectRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    contentBottomView = [[KProjectBottomOperationView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - TabBarHeight, MainScreenWidth, TabBarHeight)];
    contentBottomView.delegate = self;
    
    kUIWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, self.view.frame.size.width, MainScreenHeight - StatusBarHeight - contentBottomView.frame.size.height)];
    kUIWebView.delegate = self;
    kUIWebView.scalesPageToFit = YES;
    [self.view addSubview:kUIWebView];
    [self.view addSubview:contentBottomView];
    
    if (@available(iOS 11,*)) {
        kUIWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGes.delegate = self;
    longPressGes.minimumPressDuration = 0.35;
    [kUIWebView addGestureRecognizer:longPressGes];
    
    networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)longPressAction:(UIGestureRecognizer*)ges{
    
    if (isShowAlert == YES) {
        return;
    }
    
    CGPoint point = [ges locationInView:kUIWebView];
    NSString *jsStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src",point.x,point.y];
    
    NSString *imageUrlStr = [kUIWebView stringByEvaluatingJavaScriptFromString:jsStr];
    if ([imageUrlStr length] > 0) {
        isShowAlert = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrlStr]
                                                                  options:SDWebImageDownloaderHighPriority
                                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                                }];
            self->isShowAlert = NO;
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self->isShowAlert = NO;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark 图片保存的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"图片保存失败，无法访问相册"
                                                                            message:@"请在“设置>隐私>照片”打开相册访问权限"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)performOperationWithStyle:(KProjectBottomOperationStyle)style{
    switch (style) {
        case KProjectBottomOperationStyleGoBack:
        {
            if ([kUIWebView canGoBack]) {
                [kUIWebView goBack];
            }
        }
            break;
        case KProjectBottomOperationStyleGoForward:
        {
            if ([kUIWebView canGoForward]) {
                [kUIWebView goForward];
            }
        }
            break;
        case KProjectBottomOperationStyleRefresh:
        {
            [kUIWebView reload];
        }
            break;
        case KProjectBottomOperationStyleMenu:
        {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:@"是否使用浏览器打开?" preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openContentUseB];
            }]];
            
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        case KProjectBottomOperationStyleHomePage:
        {
            [self loadMainPageContent];
        }
            break;
            
        default:
            break;
    }
}

- (void)openContentUseB{
    NSURL *url = kUIWebView.request.URL;
    if (url == nil || [url.absoluteString isBlankString]) {
        url = [NSURL URLWithString:self.urlString];
    }
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [SVProgressHUD showInfoWithStatus:@"加载失败"];
    }
}

#pragma mark 无网提示视图
- (KProjectNetworkDisConnectedView*)noNetworkAlertView{
    if (_noNetworkAlertView == nil) {
        _noNetworkAlertView = [[KProjectNetworkDisConnectedView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        [self.view addSubview:_noNetworkAlertView];
    }
    
    [_noNetworkAlertView reloadCellular];
    [self.view bringSubviewToFront:_noNetworkAlertView];
    
    return _noNetworkAlertView;
}

- (void)networkStatusDidChanged:(NSNotification*)info{
    NSDictionary *inforDict = [info userInfo];
    if (inforDict) {
        NSString *statusStr = [NSObject getStringFromDict:inforDict withKey:AFNetworkingReachabilityNotificationStatusItem];
        if (statusStr == nil || [statusStr isBlankString]) {
            statusStr = [NSObject getStringFromDict:inforDict withKey:@"LCNetworkingReachabilityNotificationStatusItem"];
        }
        NSInteger status   = [statusStr integerValue];
        if (status != networkStatus) {
            networkStatus = status;
            if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
                self.noNetworkAlertView.hidden = NO;
            }else{
                if (_noNetworkAlertView) {
                    _noNetworkAlertView.hidden = YES;
                }
                
                NSURL *url = kUIWebView.request.URL;
                if (url == nil || [url.absoluteString isBlankString]) {
                    [self loadMainPageContent];
                }
            }
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self networkWatingViewDismissFromView:kUIWebView];
    NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL.absoluteString];
    if ([self jumpsToThirdAPP:urlStr]) {
        return NO;
    }
    
    if ([urlStr hasPrefix:@"itms"] || [urlStr hasPrefix:@"itunes.apple.com"] ) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"在App Store中打开?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:url];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            return NO;
        }else{
            [SVProgressHUD showInfoWithStatus:@"跳转失败"];
        }
    }
    
    //如果是跳转的是需要浏览器打开的页面则不允许跳转并用浏览器打开
    NSString *openUseBrowser = @"UseBrowser";
    if ([urlStr hasPrefix:@"my"] || [urlStr rangeOfString:openUseBrowser].location != NSNotFound) {
        NSMutableString *mutableStr=[[NSMutableString alloc]initWithString:urlStr];
        if ([urlStr hasPrefix:@"my"]) {
            [mutableStr deleteCharactersInRange:NSMakeRange(0, 2)];
        }
        if ([mutableStr rangeOfString:openUseBrowser].location != NSNotFound) {
            mutableStr = [mutableStr stringByReplacingOccurrencesOfString:openUseBrowser withString:@""].mutableCopy;
        }
        if ([self jumpsToThirdAPP:mutableStr]) {
            return NO;
        }else{
            NSURL *url = [NSURL URLWithString:mutableStr];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                BOOL canOpen = [[UIApplication sharedApplication] openURL:url];
                if (canOpen == YES) {
                    NSLog(@"跳转到浏览器成功");
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (BOOL)jumpsToThirdAPP:(NSString *)urlStr{
    if ([urlStr hasPrefix:@"mqq"] ||
        [urlStr hasPrefix:@"weixin"] ||
        [urlStr hasPrefix:@"alipay"]) {
        BOOL success = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
        if (success) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }else{
            NSString *appurl = [urlStr hasPrefix:@"alipay"]?@"https://itunes.apple.com/cn/app/%E6%94%AF%E4%BB%98%E5%AE%9D-%E8%AE%A9%E7%94%9F%E6%B4%BB%E6%9B%B4%E7%AE%80%E5%8D%95/id333206289?mt=8":([urlStr hasPrefix:@"weixin"]?@"https://itunes.apple.com/cn/app/%E5%BE%AE%E4%BF%A1/id414478124?mt=8":@"https://itunes.apple.com/cn/app/qq/id444934666?mt=8");
            NSString *title = [urlStr hasPrefix:@"mqq"]?@"QQ":([urlStr hasPrefix:@"weixin"]?@"微信":@"支付宝");
            NSString *titleString = [NSString stringWithFormat:@"该设备未安装%@客户端",title];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:titleString preferredStyle:UIAlertControllerStyleAlert];
            
            [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [controller addAction:[UIAlertAction actionWithTitle:@"立即安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:appurl];
                [[UIApplication sharedApplication] openURL:url];
            }]];
            [self presentViewController:controller animated:YES completion:nil];
        }
        return YES;
    }
    
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showNetworkWatingViewInView:kUIWebView withContent:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self networkWatingViewDismissFromView:kUIWebView];
    if ([self isAppDomain]) {
        NSString *str=str = @"function getRefs() { \
                                var oA = document.getElementsByTagName('a');\
                                var length = oA.length;\
                                for(var i= 0;i<length;i++){\
                                    var hreff = oA[i].getAttribute(\"href\");\
                                    var current = oA[i].getAttribute(\"class\");\
                                    if(current == 'appweb'){\
                                    oA[i].setAttribute(\"href\", \"my\" + hreff);}}}\
                            getRefs();";
        [kUIWebView stringByEvaluatingJavaScriptFromString:str];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self networkWatingViewDismissFromView:kUIWebView];
}

- (BOOL)isAppDomain{
    NSString *current = [kUIWebView.request.URL absoluteString];
    if ((current == nil || [current isBlankString]) ||
        (self.urlString == nil || [self.urlString isBlankString])) {
        return YES;
    }
    
    NSString *host = [kUIWebView.request.URL host];
    if ([self.urlString rangeOfString:host].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

#pragma mark 加载主页面
- (void)loadMainPageContent{
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [kUIWebView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *name = [kUIWebView.request.URL absoluteString];
    if (name == nil || [name isBlankString]) {
        [self loadMainPageContent];
    }
}

-(void)showNetworkWatingViewInView:(UIView*)view withContent:(NSString*)content{
    MBProgressHUD *h = [MBProgressHUD showHUDAddedTo:view animated:YES];
    h.label.text = content;
    h.removeFromSuperViewOnHide = YES;
}
-(void)networkWatingViewDismissFromView:(UIView*)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

#pragma mark 设置web的frame
- (void)resetContentWebFrame{
    CGFloat originY = IsPortrait?(iPhoneX?(StatusBarHeight-10):StatusBarHeight):0;
    CGFloat height  = contentBottomView.frame.origin.y - originY;
    
    kUIWebView.frame = CGRectMake(0, originY, MainScreenWidth, height);
    
    CGFloat y = 0;//IsPortrait?(IOS11?0:0):0;
    kUIWebView.scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
    kUIWebView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat height  = IsPortrait?TabBarHeight:BGNaviBarHeight;
    CGFloat originY = IsPortrait?(MainScreenHeight - height):MainScreenHeight;
    contentBottomView.frame = CGRectMake(0, originY, MainScreenWidth, height);
    
    [self resetContentWebFrame];
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable ||
        networkStatus == AFNetworkReachabilityStatusUnknown) {
        self.noNetworkAlertView.hidden = NO;
    }else{
        if (_noNetworkAlertView) {
            _noNetworkAlertView.hidden = YES;
        }
    }
    
    if (_noNetworkAlertView) {
        _noNetworkAlertView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - (IsPortrait?TabBarHeight:0));
    }
}

- (BOOL)prefersStatusBarHidden{
    return !IsPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
