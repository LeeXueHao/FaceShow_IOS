//
//  YXPlayerViewController.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXPlayerViewController.h"
#import "LePlayer.h"
#import "LePlayerView.h"
#import "YXPlayerTopView.h"
#import "YXPlayerBottomView.h"
#import "YXPlayerBufferingView.h"
#import "AppDelegate.h"
#import "PreventHangingCourseView.h"

static NSInteger kPreventHangingCourseDefaultTime = 600;
@implementation YXPlayerDefinition

- (BOOL)isEqual:(id)object {
    YXPlayerDefinition *rhs = object;
    if ([self.identifier isEqualToString:rhs.identifier]) {
        return YES;
    }
    return NO;
}

@end


static const NSTimeInterval kTopBottomHiddenTime = 5;

@interface YXPlayerViewController() {
    NSDate *_startTime;
    NSTimeInterval _playTime;
    BOOL _bDefinitionShown;
    
    NSMutableArray *_internalDefinitionArray;
    YXPlayerDefinition *_internalDefaultDefinition;
    NSMutableArray *_defButtonArray;
    
    BOOL _bShowDefinition;
}
@property (nonatomic, strong) YXPlayerTopView *topView;
@property (nonatomic, strong) YXPlayerBottomView *bottomView;
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) UIView *gestureView;

@property (nonatomic, assign) BOOL bTopBottomHidden;
@property (nonatomic, strong) NSTimer *topBottomHideTimer;

@property (nonatomic, strong) NSMutableArray *disposableArray;


@property (nonatomic, assign) NSInteger preventHangingCourseInteger;
@property (nonatomic, strong) dispatch_source_t preventHangingCourseTime;
@property (nonatomic, strong) PreventHangingCourseView *preventView;
@end

@implementation YXPlayerViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    _playTime = 0;
    _preventHangingCourseInteger = 0;
    self.bottomView = [[YXPlayerBottomView alloc] init];
    [self _setupDefinitions];
    if (!isEmpty(_internalDefaultDefinition.url)) {
        self.videoUrl = _internalDefaultDefinition.url;
    }
    
    _bDefinitionShown = NO;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(preProgress)]) {
        self.preProgress = [self.delegate preProgress];
        if (self.preProgress > 0.99) {
            self.preProgress = 0;
        }
    }
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.player = [[LePlayer alloc] init];
    self.player.progress = self.preProgress;
    self.playerView = (LePlayerView *)[self.player playerViewWithFrame:CGRectZero];
    self.playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    self.topView = [[YXPlayerTopView alloc] init];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@43);
    }];
    
    //self.bottomView = [[YXPlayerBottomView alloc] init];
    self.bottomView.bShowDefinition = _bShowDefinition;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@43).priorityHigh();
    }];

    [self.topView.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.slideProgressView addTarget:self action:@selector(progressAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.playPauseButton addTarget:self action:@selector(playPauseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.forwardButton addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topView.backButton addTarget:self action:@selector(invalidateTopBottomHiddenTimer) forControlEvents:UIControlEventTouchDown];
    [self.bottomView.slideProgressView addTarget:self action:@selector(invalidateTopBottomHiddenTimer) forControlEvents:UIControlEventTouchDown];
    [self.bottomView.playPauseButton addTarget:self action:@selector(invalidateTopBottomHiddenTimer) forControlEvents:UIControlEventTouchDown];
    
    [self setupObserver];
    // 开始播放
    //[self checkNetwork];
    // 开始播放
    if (self.bIsLocalFile) {
        self.player.videoUrl = [NSURL fileURLWithPath:self.videoUrl];
    } else {
        self.player.videoUrl = [NSURL URLWithString:self.videoUrl];
    }
    
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    self.bufferingView.frame = CGRectMake(20, 20, 100, 100);
    [self.view addSubview:self.bufferingView];
    [self.bufferingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(@0);
    }];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(@55);
    }];
    
    self.topView.titleLabel.text = self.title;
    [self setupGesture];
    
    //[self _setupDefinitions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];// TD: fix bug 192
    
    self.preventView = [[PreventHangingCourseView alloc] init];
    WEAK_SELF
    [self.preventView setPreventHangingCourseBlock:^{
        STRONG_SELF
        [self.player play];
    }];
    [self.view addSubview:self.preventView];
    self.preventView.hidden = YES;
    [self.preventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}
- (void)applicationDidBecomeActive:(NSNotification *)notification{
    if (self.player.state == PlayerView_State_Playing) {
        [self.player play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self backAction];
}

- (void)changeVideoUrlAndPlay:(NSString *)url {
    self.player.progress = self.bottomView.slideProgressView.playProgress;
    
    if (self.bIsLocalFile) {
        self.player.videoUrl = [NSURL fileURLWithPath:url];
    } else {
        self.player.videoUrl = [NSURL URLWithString:url];
    }
}

- (void)checkNetwork {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self.view nyx_showToast:@"网络不可用,请检查网络"];
        return;
    }
    if ([r isReachableViaWWAN] && ![r isReachableViaWiFi]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
        WEAK_SELF
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            [self backAction];
            return;
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            if (self.bIsLocalFile) {
                self.player.videoUrl = [NSURL fileURLWithPath:self.videoUrl];
            } else {
                self.player.videoUrl = [NSURL URLWithString:self.videoUrl];
            }
        }];
        [alertVC addAction:backAction];
        [alertVC addAction:goAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    if ([r isReachableViaWiFi]) {
        // 开始播放
        if (self.bIsLocalFile) {
            self.player.videoUrl = [NSURL fileURLWithPath:self.videoUrl];
        } else {
            self.player.videoUrl = [NSURL URLWithString:self.videoUrl];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.bufferingView start];
}

- (void)backAction {
    if (self.preventHangingCourseTime) {
        dispatch_source_cancel(self.preventHangingCourseTime);
    }
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(playerProgress:totalDuration:stayTime:)]) {
        if (self.player.duration) {
            if (self->_startTime) {
                self->_playTime += [[NSDate date]timeIntervalSinceDate:self->_startTime];
            }
            [self.delegate playerProgress:self.bottomView.slideProgressView.playProgress totalDuration:self.player.duration stayTime:self->_playTime];
        }
    }

    
    [self invalidateTopBottomHiddenTimer];
    for (RACDisposable *d in self.disposableArray) {
        [d dispose];
    }
    
    [self.player pause];
    
    self.player = nil;
//    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    SAFE_CALL(self.exitDelegate, browserExit);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)recordPlayerDuration {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(playerProgress:totalDuration:stayTime:)]) {
        if (self.player.duration) {
            if (self->_startTime) {
                self->_playTime += [[NSDate date]timeIntervalSinceDate:self->_startTime];
            }
            [self.delegate playerProgress:self.bottomView.slideProgressView.playProgress totalDuration:self.player.duration stayTime:self->_playTime];
            self->_playTime = 0;
            self->_startTime = nil;
        }
    }
}

- (void)progressAction {
    [self resetTopBottomHideTimer];
    [self.player seekTo:self.player.duration * self.bottomView.slideProgressView.playProgress];
}

- (void)playPauseAction {
    [self resetTopBottomHideTimer];
    if (self.player.state == PlayerView_State_Paused) {
        [self.player play];
    } else if (self.player.state == PlayerView_State_Finished) {
        [self.player seekTo:0];
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)do3GCheck {
    [self.player pause];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self backAction];
        return;
    }];
    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self.player play];
    }];
    [alertVC addAction:backAction];
    [alertVC addAction:goAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)setupObserver {
    // 2G / wifi
    Reachability *r = [Reachability reachabilityForInternetConnection];
    // 播放中，网络切换为2G
    @weakify(r);
    @weakify(self);
    [r setReachableBlock:^void (Reachability * reachability) {
        @strongify(r);
        @strongify(self); if (!self) return;;
        if([r isReachableViaWiFi]) {
            return;
        }
        
        if([r isReachableViaWWAN]) {
            [self do3GCheck];
        }
    }];
    [r startNotifier];
    
    self.disposableArray = [NSMutableArray array];
    RACDisposable *r0 = [RACObserve(self.player, state) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        if ([x unsignedIntegerValue] == PlayerView_State_Playing) {
            self->_startTime = [NSDate date];
        } else {
            if (self->_startTime) {
                self->_playTime += [[NSDate date]timeIntervalSinceDate:self->_startTime];
                self->_startTime = nil;
            }
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
            if ([x unsignedIntegerValue] == PlayerView_State_Buffering) {
                self.bufferingView.hidden = NO;
                [self.bufferingView start];
            } else {
                self.bufferingView.hidden = YES;
                [self.bufferingView stop];
            }
//        });
        
        switch ([x unsignedIntegerValue]) {
            case PlayerView_State_Buffering:
                DDLogInfo(@"buffering");
                break;
            case PlayerView_State_Playing:
                DDLogInfo(@"Playing");
                [self.bottomView setPlaying];
                break;
            case PlayerView_State_Paused:
                DDLogInfo(@"Paused");
                [self.bottomView setPaused];
                break;
            case PlayerView_State_Finished:
                DDLogInfo(@"Finished");
                [self backAction];
                break;
            case PlayerView_State_Error:
            {
                DDLogError(@"Error");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bufferingView stop];
                    self.bufferingView.hidden = YES;
                    [self.view nyx_showToast:@"播放失败！"];
                });
                break;
            }
            default:
                break;
        }
    }];
    
    RACDisposable *r1 = [self.player rac_observeKeyPath:@"bIsPlayable"
                                                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               observer:self
                                                  block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                                                      @strongify(self); if (!self) return;
                                                      if ([value boolValue]) {
                                                          self.bufferingView.hidden = YES;
                                                          [self.bufferingView stop];
                                                          [self showTop];
                                                          [self showBottom];
                                                          self.bTopBottomHidden = NO;
                                                          [self resetTopBottomHideTimer];
                                                          self.gestureView.userInteractionEnabled = YES;
                                                      }
                                                  }];
    
    RACDisposable *r2 = [RACObserve(self.player, duration) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
//        if (isEmpty(self->_startTime)) {
//            self->_startTime = [NSDate date];
//        }
        
        self.bottomView.slideProgressView.duration = [x doubleValue];
        if (self.bottomView.slideProgressView.bufferProgress > 0) { // walkthrough 换url时slide跳动
            [self.bottomView.slideProgressView updateUI];
        }
    }];
    
    RACDisposable *r3 = [RACObserve(self.player, timeBuffered) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        if (self.bottomView.slideProgressView.bSliding) {
            return;
        }
        
        if (self.bottomView.slideProgressView.duration > 0) {
            self.bottomView.slideProgressView.bufferProgress = [x floatValue] / self.bottomView.slideProgressView.duration;
            if (self.bottomView.slideProgressView.bufferProgress > 0) { // walkthrough 换url时slide跳动
                [self.bottomView.slideProgressView updateUI];
            }
        }
    }];

    RACDisposable *r4 = [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        if (self.bottomView.slideProgressView.bSliding) {
            return;
        }
        
        if (self.bottomView.slideProgressView.duration > 0) {
            self.bottomView.slideProgressView.playProgress = [x floatValue] / self.bottomView.slideProgressView.duration;
            if (self.bottomView.slideProgressView.playProgress > 0) { // walkthrough 换url时slide跳动
                [self.bottomView.slideProgressView updateUI];
            }
        }
    }];
    
//    RACDisposable *r5 = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
//        @strongify(self); if (!self) return;
//        if (self->_startTime) {
//            self->_startTime = [NSDate date];
//        }
//    }];

    [self.disposableArray addObject:r0];
    [self.disposableArray addObject:r1];
    [self.disposableArray addObject:r2];
    [self.disposableArray addObject:r3];
    [self.disposableArray addObject:r4];
//    [self.disposableArray addObject:r5];
}

#pragma mark - top / bottom hide
- (void)resetTopBottomHideTimer {
    [self.topBottomHideTimer invalidate];
    self.topBottomHideTimer = [NSTimer scheduledTimerWithTimeInterval:kTopBottomHiddenTime
                                                               target:self
                                                             selector:@selector(topBottomHideTimerAction)
                                                             userInfo:nil
                                                              repeats:YES];
}

- (void)topBottomHideTimerAction {
    [self hideTop];
    [self hideBottom];
    self.bTopBottomHidden = YES;
}

- (void)invalidateTopBottomHiddenTimer {
    [self.topBottomHideTimer invalidate];
}

- (void)showTop {
    [UIView animateWithDuration:0.6 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@0);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)showBottom {
    [UIView animateWithDuration:0.6 animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(@0);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)hideTop {
    [UIView animateWithDuration:0.6 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@-44);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)hideBottom {
    [UIView animateWithDuration:0.6 animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(@55);
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - gestrue
- (void)setupGesture {
    self.gestureView = [[UIView alloc] init];
    self.gestureView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.gestureView];
    [self.view bringSubviewToFront:self.topView];
    [self.view bringSubviewToFront:self.bottomView];
    self.gestureView.userInteractionEnabled = NO;
    [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    [self.gestureView addGestureRecognizer:tap];
    
    [self.bottomView.definitionButton addTarget:self action:@selector(definitionButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)definitionButtonAction {
    if ([_internalDefinitionArray count] == 1) {
        return;
    }
    
    if (_bDefinitionShown) {
        [self hideDefinition];
    } else {
        [self showDefinition];
    }
    //_bDefinitionShown = !_bDefinitionShown;
}

- (void)tapAction {
    if (_bDefinitionShown) {
        [self hideDefinition];
        return;
    }
    
    if (self.bTopBottomHidden) {
        [self showTop];
        [self showBottom];
    } else {
        [self hideTop];
        [self hideBottom];
    }
    self.bTopBottomHidden = !self.bTopBottomHidden;
    [self resetTopBottomHideTimer];
}

#pragma mark - top actions
- (void)forwardAction {
    [self.view bringSubviewToFront:self.bufferingView];
    [self.bufferingView start];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)_setupDefinitions {
    self.defaultDefinition = [[YXPlayerDefinition alloc]init];
    self.defaultDefinition.identifier = [self loadDefaultDefinition];
    _internalDefinitionArray = [[NSMutableArray alloc] init];
    for (YXPlayerDefinition *def in self.definitionArray) {
        if (isEmpty(def.url)) {
            continue;
        }
        [_internalDefinitionArray addObject:def];
    }
    
    if (isEmpty(_internalDefinitionArray)) {
        _bShowDefinition = NO;
        return;

        /*YXPlayerDefinition *def = [[YXPlayerDefinition alloc] init];
        def.identifier = @"标清";
        def.url = self.videoUrl;
        [_internalDefinitionArray addObject:def];
        self.definitionArray = _internalDefinitionArray;
         */
    }
    
    _bShowDefinition = YES;
    // find the one nearest default
    NSMutableArray *seekArray = [NSMutableArray array];
    int index = (int)[self.definitionArray indexOfObject:self.defaultDefinition];
    for (int i = index; i >= 0; i--) {
        [seekArray addObject:[self.definitionArray objectAtIndex:i]];
    }
    
    for (int i = index + 1; i < [self.definitionArray count]; i++) {
        [seekArray addObject:[self.definitionArray objectAtIndex:i]];
    }
    
    for (YXPlayerDefinition *def in seekArray) {
        if (!isEmpty(def.url)) {
            _internalDefaultDefinition = def;
            break;
        }
    }
    [self.bottomView.definitionButton setTitle:_internalDefaultDefinition.identifier forState:UIControlStateNormal];
    
    
    // 做清晰图buttons
    _defButtonArray = [NSMutableArray array];
    int curIndex = 0;
    for (YXPlayerDefinition *def in _internalDefinitionArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:def.identifier forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"868686"] forState:UIControlStateNormal];
        if (curIndex == 0) {
            // 第一个
            [btn setBackgroundImage:[UIImage imageNamed:@"流畅button"] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"高清标清button"] forState:UIControlStateNormal];
        }
        curIndex++;
        [_defButtonArray addObject:btn];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(definitionChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self.bottomView.definitionButton setTitle:_internalDefaultDefinition.identifier
                                      forState:UIControlStateNormal];
}

- (void)showDefinition {
    _bDefinitionShown = YES;
    //self.gestureView.userInteractionEnabled = NO;
    [self invalidateTopBottomHiddenTimer];
    
    for (UIButton *btn in _defButtonArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 34));
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.view.mas_bottom);
        }];
        btn.alpha = 0;
    }
    [self.view layoutIfNeeded];
    
    CGFloat yOffset = -60;
    for (UIButton *btn in _defButtonArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 34));
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(yOffset);
        }];
        btn.alpha = 1;
        yOffset -= 38;
        [self.view bringSubviewToFront:btn];
        [self.view layoutIfNeeded];
    }
}

- (void)hideDefinition {
    _bDefinitionShown = NO;
    //self.gestureView.userInteractionEnabled = YES;
    [self resetTopBottomHideTimer];
    
    for (UIButton *btn in _defButtonArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 34));
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.view.mas_bottom);
        }];
        btn.alpha = 0;
    }
    [self.view layoutIfNeeded];
}

- (void)definitionChooseAction:(UIButton *)btn {
    int index = (int)[_defButtonArray indexOfObject:btn];
    YXPlayerDefinition *def = [_internalDefinitionArray objectAtIndex:index];
    [self.bottomView.definitionButton setTitle:def.identifier forState:UIControlStateNormal];
    [self changeVideoUrlAndPlay:def.url];
    
    _bDefinitionShown = NO;
    [self hideDefinition];
    
    [self saveDefaultDefinition:def.identifier];
//    [YXGPGlobalSingleton sharedInstance].defaultDefinition = def.identifier;
}

#pragma mark - 默认清晰度的保存与读取
- (void)saveDefaultDefinition:(NSString *)definitionID{
//    [[NSUserDefaults standardUserDefaults]setValue:definitionID forKey:@"kPlayerDefaultDefinition"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSString *)loadDefaultDefinition{
    return @"标清";
//    NSString *definitionID = [[NSUserDefaults standardUserDefaults]valueForKey:@"kPlayerDefaultDefinition"];
//    if (!definitionID) {
//        return @"标清";
//    }
//    return definitionID;
}

- (void)startPreventHangingCourseTime {
    WEAK_SELF
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.preventHangingCourseTime = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.preventHangingCourseTime, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0.0f);
    dispatch_source_set_event_handler(self.preventHangingCourseTime, ^{
        STRONG_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.player.state == PlayerView_State_Playing) {
                self.preventHangingCourseInteger ++;
            }
        });
    });
    dispatch_resume(self.preventHangingCourseTime);
}
- (void)setPreventHangingCourseInteger:(NSInteger)preventHangingCourseInteger {
    if (_preventHangingCourseInteger/kPreventHangingCourseDefaultTime !=
        preventHangingCourseInteger/kPreventHangingCourseDefaultTime) {
        [self.player pause];
        self.preventView.hidden = NO;
    }
    _preventHangingCourseInteger = preventHangingCourseInteger;
}

@end
