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

@interface ResourceDisplayViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) FileDownloadHelper *downloadHelper;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ResourceDisplayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.naviBarHidden animated:NO];
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
    
    if (self.needDownload) {
        [self downloadFile];
    } else {
        [self setupUI];
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
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.view bringSubviewToFront:self.backButton];
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


@end
