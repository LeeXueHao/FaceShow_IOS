//
//  IMGroupMemberView.m
//  FaceShowApp
//
//  Created by SRT on 2018/10/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMGroupMemberView.h"

@interface IMGroupMemberView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *nextImageView;
@end

@implementation IMGroupMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    self.titleLabel = titleLabel;

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_offset(1.0f);
    }];

    self.nextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"进入页面按钮正常态"]];
    [self addSubview:self.nextImageView];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5.0f);
        make.centerY.mas_equalTo(0);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];

    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];

}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)tapAction{
    BLOCK_EXEC(self.clickContentBlock);
}


@end
