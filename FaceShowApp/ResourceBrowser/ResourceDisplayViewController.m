//
//  ResourceDisplayViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceDisplayViewController.h"
#import "FileDownloadHelper.h"

@interface ResourceDisplayViewController ()<UIWebViewDelegate>
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
    UIWebView *webview = [[UIWebView alloc]init];
    webview.scalesPageToFit = YES;
    webview.delegate = self;
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

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view nyx_startLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view nyx_stopLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view nyx_stopLoading];
    [self.view nyx_showToast:@"资源加载失败"];
}

@end
