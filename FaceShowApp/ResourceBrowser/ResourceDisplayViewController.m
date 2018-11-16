//
//  ResourceDisplayViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceDisplayViewController.h"
#import "FileDownloadHelper.h"
#import <WebKit/WebKit.h>
#import "ResourceDownloadViewController.h"

@interface ResourceDisplayViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) FileDownloadHelper *downloadHelper;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, assign) BOOL needReload;
@end

@implementation ResourceDisplayViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.needReload = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.naviBarHidden animated:NO];
    if (self.needReload) {
        [self.webview reload];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.needReload = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    if (self.naviBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        UIImage *normalImage = self.backNormalImage? :[UIImage imageNamed:@"返回页面按钮正常态-"];
        UIImage *highlightImage = self.backHighlightImage? :[UIImage imageNamed:@"返回页面按钮点击态"];
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, normalImage.size.width+20, normalImage.size.height+20)];
        [backButton setImage:normalImage forState:UIControlStateNormal];
        [backButton setImage:highlightImage forState:UIControlStateHighlighted];
        WEAK_SELF
        [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            STRONG_SELF
            [self backAction];
        }];
        [self.view addSubview:backButton];
        self.backButton = backButton;
    }

    WEAK_SELF
    if (self.needDownload) {
        [self downloadFile];
        if ([UserManager sharedInstance].configItem.data.resourceDown) {
            [self nyx_setupRightWithTitle:@"下载" action:^{
                STRONG_SELF
                [TalkingData trackEvent:@"资源下载"];
                ResourceDownloadViewController *downLoad = [[ResourceDownloadViewController alloc] init];
                downLoad.resourceId = self.resourceId;
                downLoad.downloadUrl = self.downloadUrl;
                [self.navigationController pushViewController:downLoad animated:YES];
            }];
        }
    } else {
        [self setupUI];
        [self nyx_setupRightWithImageName:@"分享" highlightImageName:@"分享" action:^{
            STRONG_SELF
            [self shareUrl];
        }];
    }
}

- (void)setupUI {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.mediaPlaybackRequiresUserAction = false;

    WKWebView *webview = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    if (@available(iOS 11.0, *)) {
        webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    webview.navigationDelegate = self;
    if (self.needDownload) {
        NSURL *url = [NSURL fileURLWithPath:self.urlString isDirectory:NO];
        [webview loadFileURL:url allowingReadAccessToURL:url];
    } else {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
        [webview loadRequest:request];
    }
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.view bringSubviewToFront:self.backButton];
    self.webview = webview;
}

- (void)downloadFile {
    self.downloadHelper = [[FileDownloadHelper alloc] initWithURLString:self.urlString baseViewController:self];
    WEAK_SELF
    [self.downloadHelper startDownloadWithCompleteBlock:^(NSString *path) {
        STRONG_SELF
        self.urlString = path;
        [self setupUI];
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.view nyx_startLoading];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view nyx_stopLoading];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [self.view nyx_stopLoading];
    [self.view nyx_showToast:@"资源加载失败"];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

#pragma mark - action
- (void)shareUrl{
    NSArray *items = @[self.urlString];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
    };
    if ([activityVC respondsToSelector:@selector(popoverPresentationController)]) {
        UIPopoverPresentationController *popover = activityVC.popoverPresentationController;
        if (popover) {
            popover.sourceView = self.webview;
            popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
        }
    }
    [self presentViewController:activityVC animated:YES completion:NULL];
}

@end
