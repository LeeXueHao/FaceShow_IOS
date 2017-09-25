//
//  ScanCodeMaskView.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScanCodeMaskView.h"

@interface ScanCodeMaskView ()

@property (nonatomic, assign) NSInteger scanCount;
@property (nonatomic, strong) UIImageView *scanLineImageView;

@end

@implementation ScanCodeMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scanCount = 0;
        [self setupUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[[UIColor blackColor] colorWithAlphaComponent:.6f] setFill];
    CGContextFillRect(ctx, rect);
    CGContextClearRect(ctx, CGRectMake(SCREEN_WIDTH / 2 - 121, 107 * kPhoneHeightRatio, 243, 243));
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor clearColor];
    middleView.layer.cornerRadius = 10;
    middleView.layer.borderWidth = 4;
    middleView.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    [self addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(103 * kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250, 250));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"将二维码放入扫描区域";
    titleLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
    }];
    
    self.scanLineImageView = [[UIImageView alloc] init];
    self.scanLineImageView.image = [UIImage imageNamed:@"扫描"];
    [self addSubview:self.scanLineImageView];
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
}

- (void)scanAnimation {
    self.scanCount ++;
    self.scanLineImageView.frame = CGRectMake(SCREEN_WIDTH / 2 - 125, 103 * kPhoneHeightRatio + self.scanCount, 250, 2);
    if (self.scanCount >= 250) {
        self.scanCount = 0;
    }
}

@end
