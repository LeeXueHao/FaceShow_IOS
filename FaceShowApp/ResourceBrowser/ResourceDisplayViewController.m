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
@end

@implementation ResourceDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    
    if (self.needDownload) {
        [self downloadFile];
    } else {
        [self setupUI];
    }
}

- (void)setupUI {
    WKWebView *webview = [[WKWebView alloc]init];
    webview.navigationDelegate = self;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
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
