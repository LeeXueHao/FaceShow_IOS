//
//  ForbidTalkingView.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/8/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ForbidTalkingView.h"

@interface ForbidTalkingView ()
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation ForbidTalkingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.backgroundColor = [UIColor colorWithHexString:@"a6b0bf"];
    self.descLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.descLabel.font = [UIFont boldSystemFontOfSize:14];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.text = @"当前学员为禁言状态";
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
