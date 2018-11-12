//
//  NBLiveViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBLiveViewController.h"
#import <WebKit/WebKit.h>

@interface NBLiveViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webview;
@end

@implementation NBLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
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
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.pageConf.url]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.webview = webview;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
