//
//  YXFileDownloadProgressView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileDownloadProgressView.h"
#import <MDRadialProgressView.h>
#import <MDRadialProgressTheme.h>
#import <MDRadialProgressLabel.h>

@implementation YXFileDownloadProgressView {
    MDRadialProgressView *_radialView;
}

- (id)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
    [self addSubview:radialView];
    [radialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66, 66));
        make.center.mas_equalTo(@0);
    }];
    
    radialView.progressTotal = 50;
    radialView.progressCounter = 0;
    radialView.startingSlice = 1;
    radialView.theme.sliceDividerHidden = NO;
    radialView.theme.sliceDividerThickness = 1;
    radialView.theme.labelShadowOffset = CGSizeMake(0, 0);
    // theme update works both changing the theme or the theme attributes
    radialView.theme.incompletedColor = [UIColor colorWithHexString:@"60646f"];
    radialView.theme.completedColor = [UIColor colorWithHexString:@"2c97dd"];
    
    radialView.theme.sliceDividerColor = [UIColor clearColor];
    
    radialView.label.textColor = [UIColor whiteColor];
    radialView.label.font = [UIFont systemFontOfSize:14];
    radialView.label.text  =@"0%";
    
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setImage:[UIImage imageNamed:@"进度条-关闭"] forState:UIControlStateNormal];
//    [self addSubview:closeButton];
//    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(@20);
//        make.right.mas_equalTo(@0);
//        make.size.mas_equalTo(CGSizeMake(44, 44));
//    }];
//    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(@0);
        make.top.mas_equalTo(radialView.mas_bottom).mas_offset(@10);
    }];
    
    _radialView = radialView;
}

//- (void)closeAction {
//    [self removeFromSuperview];
//    self.closeBlock();
//}

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(MAX(0, progress), 1);
    _radialView.progressCounter = (int)50 * _progress;
    _radialView.label.text = [NSString stringWithFormat:@"%d%%", (int)(100 * _progress)];
}

@end
