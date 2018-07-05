//
//  ScheduleViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ShowPhotosViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "GetScheduleListRequest.h"
#import "ScheduleDetailViewController.h"

@interface ScheduleViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) GetScheduleListRequest *request;
@property (nonatomic, strong) GetScheduleListRequestItem_Schedule *schedule;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestScheduleInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestScheduleInfo {
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request stopRequest];
    self.request = [[GetScheduleListRequest alloc] init];
    self.request.clazsId = [UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId;
    [self.request startRequestWithRetClass:[GetScheduleListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        GetScheduleListRequestItem *item = (GetScheduleListRequestItem *)retItem;
        if (item.error.code.integerValue == 210025) {
            self.emptyView.hidden = NO;
            return;
        }
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        if (isEmpty(item.data.schedules.elements)) {
            self.emptyView.hidden = NO;
            return;
        }
        self.schedule = item.data.schedules.elements[0];
        [self setModel];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    
    self.webview = [[UIWebView alloc]init];
    self.webview.scalesPageToFit = YES;
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(self.webview.mas_width).multipliedBy(1.5);
    }];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.tap.numberOfTouchesRequired = 1;
    self.tap.delegate = self;
    self.webview.userInteractionEnabled = YES;
    [self.webview addGestureRecognizer:self.tap];
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无日程";
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    self.errorView = [[ErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestScheduleInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

- (void)setModel {
    [self loadWebViewWithUrl:self.schedule.imageUrl];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    ScheduleDetailViewController *vc = [[ScheduleDetailViewController alloc]init];
    vc.urlStr = self.schedule.imageUrl;
    vc.name = self.schedule.subject;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RefreshDelegate
- (void)refreshUI {
    NSLog(@"refresh called!");
    [self requestScheduleInfo];
}

#pragma mark - UIWebView
- (void)loadWebViewWithUrl:(NSString *)url {
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [self.webview loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view nyx_startLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view nyx_stopLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view nyx_stopLoading];
    [self.view nyx_showToast:@"加载失败"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.tap)
    {
        return YES;
    }
    return NO;
}

@end
