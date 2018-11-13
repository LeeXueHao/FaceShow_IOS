//
//  NBScheduleViewController.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NBScheduleViewController.h"
#import "ShowPhotosViewController.h"
#import "EmptyView.h"
#import "ErrorView.h"
#import "GetScheduleListRequest.h"
#import "ScheduleDetailViewController.h"
#import "PersonalScheduleView.h"

@interface NBScheduleViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) PersonalScheduleView *personalScheduleView;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) GetScheduleListRequest *request;
@property (nonatomic, strong) GetScheduleListRequestItem_Schedule *schedule;
@property (nonatomic, strong) GetScheduleListRequestItem_Schedule *persionSchedule;

@end

@implementation NBScheduleViewController

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
        if (item.data.personalSchedules && item.data.personalSchedules.elements.count > 0) {
            self.persionSchedule = item.data.personalSchedules.elements[0];
        }
        [self setModel];
    }];
}

#pragma mark - setupUI
- (void)setupUI {

    self.personalScheduleView = [[PersonalScheduleView alloc] init];
    [self.view addSubview:self.personalScheduleView];
    [self.personalScheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    WEAK_SELF
    self.personalScheduleView.clickEnterBlock = ^{
        STRONG_SELF
        ScheduleDetailViewController *vc = [[ScheduleDetailViewController alloc]init];
        vc.urlStr = [NSString stringWithFormat:@"%@&token=%@",self.persionSchedule.toUrl,[UserManager sharedInstance].userModel.token];
        vc.name = self.persionSchedule.subject;
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.personalScheduleView setHidden:YES];

    self.webview = [[UIWebView alloc]init];
    self.webview.scalesPageToFit = YES;
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.right.bottom.mas_equalTo(-5);
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
    if (self.persionSchedule) {
        [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.personalScheduleView.mas_bottom).offset(15);
            make.left.mas_equalTo(15);
            make.right.bottom.mas_equalTo(-15);
            make.height.mas_equalTo(self.webview.mas_width).multipliedBy(1.5);
        }];
        [self.personalScheduleView setHidden:NO];
        [self.view setNeedsLayout];
    }else{
        [self.personalScheduleView setHidden:YES];
    }
    [self loadWebViewWithUrl:self.schedule.imageUrl ? self.schedule.imageUrl : self.schedule.attachmentInfo.previewUrl];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    ScheduleDetailViewController *vc = [[ScheduleDetailViewController alloc]init];
    vc.urlStr = self.schedule.imageUrl ? self.schedule.imageUrl : self.schedule.attachmentInfo.previewUrl;
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
