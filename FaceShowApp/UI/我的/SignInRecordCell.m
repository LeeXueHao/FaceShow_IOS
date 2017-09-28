//
//  SignInRecordCell.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInRecordCell.h"
#import "GetSignInRecordListRequest.h"

@interface SignInRecordCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SignInRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.statusImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.statusImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.timeLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setSignIn:(GetSignInRecordListRequestItem_SignIn *)signIn {
    _signIn = signIn;
    self.titleLabel.text = signIn.title;
    BOOL hasSignedIn = !isEmpty(signIn.userSignIn);
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(hasSignedIn ? -10.5f : 0);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(self.statusImageView.mas_left).offset(-5);
    }];
    self.timeLabel.text = hasSignedIn ? [signIn.userSignIn.signinTime omitSecondOfFullDateString] : @"";
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(7);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    self.statusLabel.text = hasSignedIn ? @"已签到" : @"未签到";
    self.statusLabel.textColor = [UIColor colorWithHexString:hasSignedIn ? @"333333" : @"999999"];
    self.statusImageView.image = [UIImage imageNamed:hasSignedIn ? @"已签到图标-我的" : @"未签到图标-我的"];
    [self.statusImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.statusLabel.mas_left).offset(-5);
        make.top.mas_equalTo(hasSignedIn ? 22.5f : 15);
        make.bottom.mas_equalTo(hasSignedIn ? -22.5f : -15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)setHasBottomLine:(BOOL)hasBottomLine {
    _hasBottomLine = hasBottomLine;
    self.lineView.hidden = !hasBottomLine;
}

@end
