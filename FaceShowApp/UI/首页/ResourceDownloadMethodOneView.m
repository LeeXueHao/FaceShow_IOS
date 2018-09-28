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
    copyLabel.text = @"点击下方网址复制，粘贴到浏览器中即可下载";
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

    UILabel *sourceLabel = [[UILabel alloc]init];
    sourceLabel.text = self.sourceURL;
    sourceLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    sourceLabel.font = [UIFont boldSystemFontOfSize:14];
    sourceLabel.numberOfLines = 0;
    sourceLabel.textAlignment = NSTextAlignmentCenter;
    sourceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkTapAction)];
    [sourceLabel addGestureRecognizer:tap];
    [self addSubview:sourceLabel];
    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(copyLabel.mas_bottom).mas_offset(20);
        make.left.centerX.mas_equalTo(copyLabel);
        make.bottom.mas_equalTo(-35);
    }];

}

- (void)linkTapAction{
    [[UIPasteboard generalPasteboard] setString:self.sourceURL];
    BLOCK_EXEC(self.copyBlock);
}


@end
