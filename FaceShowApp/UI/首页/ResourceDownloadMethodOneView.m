//
//  ResourceDownloadMethodOneView.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ResourceDownloadMethodOneView.h"

@interface ResourceDownloadMethodOneView()

@property (nonatomic, strong) NSString *sourceURL;

@end

@implementation ResourceDownloadMethodOneView

- (instancetype)initWithSourceUrl:(NSString *)sourceURL{
    if (self = [super init]) {
        self.sourceURL = sourceURL;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"方法一：复制链接下载";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(22);
    }];

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 6;
    [self insertSubview:backgroundView belowSubview:titleLabel];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(titleLabel).offset(-7);
        make.right.bottom.mas_equalTo(titleLabel).offset(7);
    }];

    UILabel *copyLabel = [[UILabel alloc] init];
    copyLabel.text = @"点击复制按钮，粘贴到浏览器中即可下载";
    copyLabel.textColor = [UIColor colorWithHexString:@"333333"];
    copyLabel.font = [UIFont boldSystemFontOfSize:14];
    copyLabel.textAlignment = NSTextAlignmentCenter;
    copyLabel.numberOfLines = 0;
    [self addSubview:copyLabel];
    [copyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backgroundView.mas_bottom).offset(19);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(57);
    }];

    UIButton *scanButton = [[UIButton alloc]init];
    [scanButton setTitle:@"复 制" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    scanButton.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    scanButton.layer.borderWidth = 2;
    scanButton.layer.cornerRadius = 7;
    WEAK_SELF
    [[scanButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [[UIPasteboard generalPasteboard] setString:self.sourceURL];
        BLOCK_EXEC(self.copyBlock);
    }];
    [self addSubview:scanButton];
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(copyLabel.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 40));
        make.bottom.mas_equalTo(-40);
    }];

}

- (void)linkTapAction{
    [[UIPasteboard generalPasteboard] setString:self.sourceURL];
    BLOCK_EXEC(self.copyBlock);
}


@end
