//
//  ScheduleDetailViewController.m
//  FaceShowApp
//
//  Created by ZLL on 2018/7/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "ShareManager.h"

@interface ScheduleDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, copy) NSString *webTitle;
@end

@implementation ScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
    self.webTitle = @"来自研修宝的分享";
    [self setupUI];
    // Do any additional setup after loading the view.
    WEAK_SELF
    [self nyx_setupRightWithImageName:@"分享" highlightImageName:@"分享" action:^{
        STRONG_SELF
        [self shareUrl];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.webview = [[UIWebView alloc]init];
    self.webview.scalesPageToFit = YES;
    self.webview.delegate = self;
    NSString *totalUrl;
    if ([self.urlStr containsString:@"?"]) {
        totalUrl = [NSString stringWithFormat:@"%@&userId=%@",self.urlStr,[UserManager sharedInstance].userModel.userID];
    }else{
        totalUrl = [NSString stringWithFormat:@"%@?userId=%@",self.urlStr,[UserManager sharedInstance].userModel.userID];
    }
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:totalUrl]];
    [self.webview loadRequest:request];
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view nyx_startLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view nyx_stopLoading];
    if ([self.webTitle isEqualToString:@"来自研修宝的分享"]) {
        self.webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view nyx_stopLoading];
    [self.view nyx_showToast:@"加载失败"];
}

- (void)shareUrl{

    NSString *shareUrl = [[ShareManager sharedInstance] generateShareUrlWithOriginUrl:self.urlStr];
    NSArray *items = @[self.webTitle,[NSURL URLWithString:shareUrl]];
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

@end
