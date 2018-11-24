//
//  NBLiveDetailViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBLiveDetailViewController.h"
#import <WebKit/WebKit.h>
#import "ShareManager.h"

@interface NBLiveDetailViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, copy) NSString *webTitle;
@end

@implementation NBLiveDetailViewController

- (void)dealloc{
    [self.webview removeObserver:self forKeyPath:@"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"直播";
    self.webTitle = @"来自研修宝的分享";
    [self setupUI];
    WEAK_SELF
    [self nyx_setupRightWithImageName:@"分享" highlightImageName:@"分享" action:^{
        STRONG_SELF
        [self shareUrl];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    BLOCK_EXEC(self.backBlock)
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
    NSString *totalUrl = [NSString stringWithFormat:@"%@&token=%@",self.webUrl,[UserManager sharedInstance].userModel.token];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:totalUrl]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    self.webview = webview;
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if ([self.webTitle isEqualToString:@"来自研修宝的分享"]) {
            self.webTitle = self.webview.title;
        }
    }
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

    NSArray *items = @[self.webTitle,[NSURL URLWithString:self.webUrl]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    WEAK_SELF
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        STRONG_SELF
        if (activityType == UIActivityTypeCopyToPasteboard) {
            [self.view nyx_showToast:@"已复制到剪切板上"];
        }else if (activityType == UIActivityTypeAddToReadingList){
            [self.view nyx_showToast:@"已添加到阅读列表"];
        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
