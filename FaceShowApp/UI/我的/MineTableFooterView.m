//
//  MineTableFooterView.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineTableFooterView.h"

@implementation MineTableFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI 
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.backgroundColor = [UIColor whiteColor];
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.logoutButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"2AA3EF"]] forState:UIControlStateHighlighted];
    self.logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self addSubview:self.logoutButton];
}
- (void)setupLayout {
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(34.0f);
        make.height.mas_offset(45.0f);
    }];
    
}
@end
