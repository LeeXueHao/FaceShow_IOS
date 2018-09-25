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

    UILabel *methodOneLabel = [[UILabel alloc]init];
    methodOneLabel.text = @"方法一：复制下方网址，粘贴到浏览器中即可下载";
    methodOneLabel.textColor = [UIColor colorWithHexString:@"999999"];
    methodOneLabel.font = [UIFont boldSystemFontOfSize:15];
    methodOneLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:methodOneLabel];
    [methodOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [self addSubview:methodOneLabel];

    UILabel *sourceLabel = [[UILabel alloc]init];
    sourceLabel.text = self.sourceURL;
    sourceLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    sourceLabel.font = [UIFont boldSystemFontOfSize:18];
    sourceLabel.numberOfLines = 0;
    sourceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:sourceLabel];
    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(methodOneLabel.mas_bottom).mas_offset(35);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];

    UIButton *copyButton = [[UIButton alloc] init];
    [copyButton setTitle:@"复 制" forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    copyButton.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    copyButton.layer.borderWidth = 2;
    copyButton.layer.cornerRadius = 7;
    [[copyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[UIPasteboard generalPasteboard] setString:self.sourceURL];
        BLOCK_EXEC(self.copyBlock);
    }];
    [self addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sourceLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 40));
    }];
}



@end
