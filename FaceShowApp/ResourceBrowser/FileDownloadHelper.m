//
//  FileDownloadHelper.m
//  TrainApp
//
//  Created by niuzhaowang on 2016/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "FileDownloadHelper.h"
#import "UrlDownloader.h"
#import "YXFileDownloadProgressView.h"

@interface FileDownloadHelper ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, weak) UIViewController *baseViewController;
@property (nonatomic, strong) UrlDownloader *downloader;
@property (nonatomic, strong) YXFileDownloadProgressView *progressView;
@end

@implementation FileDownloadHelper

- (void)dealloc {
    [self.downloader stop];
}

- (instancetype)init {
    return [self initWithURLString:nil baseViewController:nil];
}

- (instancetype)initWithURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController {
    if (self = [super init]) {
        self.urlString = urlString;
        self.baseViewController = baseViewController;
    }
    return self;
}

- (void)startDownloadWithCompleteBlock:(void(^)(NSString *path))completeBlock {
    self.downloader = [[UrlDownloader alloc]init];
    [self.downloader setModel:self.urlString];
    NSString *des = [self.downloader desFilePath];
    NSData *desData = [NSData dataWithContentsOfFile:des];
    if (des && desData && desData.length > 0) {
        BLOCK_EXEC(completeBlock,des);
        return;
    }
    
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self.baseViewController.view nyx_showToast:@"网络异常,请稍候重试"];
        return;
    }
    if ([r isReachableViaWWAN] && ![r isReachableViaWiFi]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
        WEAK_SELF
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return;
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            [self downloadFileWithCompleteBlock:completeBlock];
        }];
        [alertVC addAction:backAction];
        [alertVC addAction:goAction];
        [[self.baseViewController nyx_visibleViewController] presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    [self downloadFileWithCompleteBlock:completeBlock];
}

- (void)downloadFileWithCompleteBlock:(void(^)(NSString *path))completeBlock {
    NSString *des = [self.downloader desFilePath];
    self.progressView = [[YXFileDownloadProgressView alloc] init];
    WEAK_SELF
    [RACObserve(self.downloader, progress) subscribeNext:^(id x) {
        STRONG_SELF
        self.progressView.progress = [x floatValue];
    }];
    [RACObserve(self.downloader, state) subscribeNext:^(id x) {
        STRONG_SELF
        if ([x intValue] == DownloadStatusFinished) {
            [self.progressView removeFromSuperview];
            BLOCK_EXEC(completeBlock,des);
        }
        
        if ([x intValue] == DownloadStatusFailed) {
            [self.progressView removeFromSuperview];
            [self.baseViewController.view nyx_showToast:@"加载失败"];
        }
    }];
    self.progressView.titleLabel.text = @"文件加载中...";
    [self.baseViewController.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.downloader start];
}

@end
