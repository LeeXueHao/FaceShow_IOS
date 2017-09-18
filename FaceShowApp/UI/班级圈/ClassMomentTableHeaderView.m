//
//  ClassMomentTableHeaderView.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentTableHeaderView.h"
@interface ClassMomentTableHeaderView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *nameLabel;
@end
@implementation ClassMomentTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.backgroundImageView];
    
    self.userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userHeaderButton.backgroundColor = [UIColor blueColor];
    self.userHeaderButton.clipsToBounds = YES;
    self.userHeaderButton.layer.cornerRadius = 5.0f;
    self.userHeaderButton.layer.shadowColor = [[UIColor colorWithHexString:@"000000"] colorWithAlphaComponent:0.2f].CGColor;
    self.userHeaderButton.layer.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:self.userHeaderButton];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.text = @"孙长龙拉拉";
    [self addSubview:self.nameLabel];
}
- (void)setupLayout {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-21.0f);
        make.height.mas_offset(270.0f);
    }];
    
    [self.userHeaderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f, 80.0f));
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.top.equalTo(self.mas_top).offset(76.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userHeaderButton.mas_left).offset(-15.0f);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-15.0f);
        make.left.equalTo(self.mas_left).offset(15.0f);
    }];
}

@end
