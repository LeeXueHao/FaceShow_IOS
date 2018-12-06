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
#import "LiveNavigationView.h"

@interface NBLiveDetailViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) LiveNavigationView *naviView;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, strong) NSURL *shareUrl;
@property (nonatomic, assign) CGFloat contentOffsetY;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL hasShowNavi;
@property (nonatomic, assign) BOOL isShowNavi;
@end

@implementation NBLiveDetailViewController

- (void)dealloc{
    [self.webview removeObserver:self forKeyPath:@"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"直播";
    self.shareTitle = @"来自研修宝的分享";
    [self setupUI];
    WEAK_SELF
    [self nyx_setupRightWithImageName:@"分享" highlightImageName:@"分享点击态" action:^{
        STRONG_SELF
        [self startShare];
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
    webview.scrollView.delegate = self;
    NSString *totalUrl = [NSString stringWithFormat:@"%@&token=%@",self.webUrl,[UserManager sharedInstance].userModel.token];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:totalUrl]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.webview = webview;

    self.naviView = [[LiveNavigationView alloc] init];
    self.naviView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view insertSubview:self.naviView aboveSubview:webview];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(40);
    }];
    WEAK_SELF
    self.naviView.forwardActionBlock = ^{
        STRONG_SELF
        if (self.webview.canGoForward) {
            [self.webview goForward];
        }
    };

    self.naviView.backActionBlock = ^{
        STRONG_SELF
        if (self.webview.canGoBack) {
            [self.webview goBack];
        }
    };
    self.isFirstLoad = NO;
    self.hasShowNavi = NO;

}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if ([self.shareTitle isEqualToString:@"来自研修宝的分享"]) {
            self.shareTitle = self.webview.title;
            self.navigationItem.title = self.shareTitle;
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
    self.shareUrl = navigationResponse.response.URL;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.view nyx_startLoading];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view nyx_stopLoading];
    if (!self.isFirstLoad) {
        self.isFirstLoad = YES;
    }else{
        if (self.hasShowNavi) {
            if (!webView.canGoBack) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.naviView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(self.view.mas_bottom).offset(40);
                    }];
                } completion:^(BOOL finished) {
                    self.hasShowNavi = NO;
                }];
            }else{

            }
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                [self.naviView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view.mas_bottom);
                }];
            }completion:^(BOOL finished) {
                self.hasShowNavi = YES;
            }];
        }
        [self.naviView refreshForwardEnabled:webView.canGoForward backEnabled:webView.canGoBack];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [self.view nyx_stopLoading];
    [self.view nyx_showToast:@"资源加载失败"];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.hasShowNavi) {
        if (self.contentOffsetY > scrollView.contentOffset.y) {
            //向上滑 若未显示 显示
            if (!self.isShowNavi) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.naviView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(self.view.mas_bottom);
                    }];

                } completion:^(BOOL finished) {
                    self.isShowNavi = YES;
                }];
            }
        }else{
            //向下滑  若已显示 隐藏
            if (self.isShowNavi) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.naviView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(self.view.mas_bottom).offset(40);
                    }];
                    [self.webview mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(self.view.mas_bottom);
                    }];
                } completion:^(BOOL finished) {
                    self.isShowNavi = NO;
                }];
            }
        }
    }
    self.contentOffsetY = scrollView.contentOffset.y;
}

#pragma mark - action
- (void)startShare{

    NSArray *items = @[self.shareTitle,self.shareUrl];
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
