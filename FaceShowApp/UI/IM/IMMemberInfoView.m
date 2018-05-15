//
//  IMMemberInfoView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/5/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMMemberInfoView.h"

@interface IMMemberInfoView ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation IMMemberInfoView

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
    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 6;
    self.headImageView.clipsToBounds = YES;
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setMember:(IMMember *)member {
    _member = member;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:[UIImage imageNamed:@"我个人头像默认图"]];
    self.nameLabel.text = member.name;
}

@end
