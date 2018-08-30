//
//  YXPlayerBottomView.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXPlayerBottomView.h"
#import "LePlayer.h"

@implementation YXPlayerBottomView {
    PlayerView_State _playPauseState;
}

- (id)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

UIView *_sepView;
- (void)_setupUI {
    //self.backgroundColor = [[UIColor colorWithHexString:@"#1f1f1f"] colorWithAlphaComponent:0.2];
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal];
    [self addSubview:self.playPauseButton];
    
    [self.playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10.0f);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
    
    self.slideProgressView = [[YXSlideProgressView alloc] init];
    self.slideProgressView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.slideProgressView];
    
    [self.slideProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(55.0f);
        make.right.mas_equalTo(-80);
        make.top.bottom.mas_equalTo(@0);
    }];

    [self.slideProgressView updateUI];
    
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = [UIColor colorWithHexString:@"#868686"];
    [self addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1).priorityLow();
        make.left.mas_equalTo(self.slideProgressView.mas_right);
        make.top.bottom.mas_equalTo(0);
    }];
    _sepView = sep;
    
    self.definitionButton = [[UIButton alloc] init];
    [self.definitionButton setTitleColor:[UIColor colorWithHexString:@"#868686"] forState:UIControlStateNormal];
    [self addSubview:self.definitionButton];
    [self.definitionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sep.mas_right);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setPlaying {
    _playPauseState = PlayerView_State_Playing;
    [self.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal];
}

- (void)setPaused {
    _playPauseState = PlayerView_State_Paused;
    [self.playPauseButton setImage:[UIImage imageNamed:@"播放视频"] forState:UIControlStateNormal];
}

- (void)setBShowDefinition:(BOOL)bShowDefinition {
    _bShowDefinition = bShowDefinition;
    if (bShowDefinition) {
        [self.slideProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playPauseButton.mas_right).mas_offset(@10);
            make.right.mas_equalTo(-80);
            make.top.bottom.mas_equalTo(@0);
        }];
        _sepView.hidden = NO;
        self.definitionButton.hidden = NO;
    } else {
        [self.slideProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playPauseButton.mas_right).mas_offset(@10);
            make.right.mas_equalTo(0);
            make.top.bottom.mas_equalTo(@0);
        }];
        _sepView.hidden = YES;
        self.definitionButton.hidden = YES;
    }
}
@end
