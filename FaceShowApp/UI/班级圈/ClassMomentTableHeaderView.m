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

@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIView *lineView;


@end
@implementation ClassMomentTableHeaderView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setMessageInteger:(NSInteger)messageInteger {
    _messageInteger = messageInteger;
    [self.messageButton setTitle:[NSString stringWithFormat:@"%ld条新消息",(long)_messageInteger] forState:UIControlStateNormal];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kYXUploadUserPicSuccessNotification" object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            [self reload];
        }];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.image = [UIImage imageNamed:@"背景图片"];
    [self addSubview:self.backgroundImageView];
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = 5.0f;
    view.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    view.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowOpacity = 0.2f;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f, 80.0f));
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.top.equalTo(self.mas_top).offset(73.0f);
    }];
    
    
    
    self.userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userHeaderButton.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [self.userHeaderButton sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"]];
    WEAK_SELF
    [[self.userHeaderButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentUserButtonBlock,1);
    }];
    self.userHeaderButton.layer.masksToBounds = YES;
    self.userHeaderButton.layer.cornerRadius = 5.0f;
    self.userHeaderButton.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    self.userHeaderButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.userHeaderButton.layer.shadowOpacity = 0.2;
    [self addSubview:self.userHeaderButton];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.text = [UserManager sharedInstance].userModel.realName?:@"暂无";
    [self addSubview:self.nameLabel];
    
    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageButton.backgroundColor = [UIColor colorWithHexString:@"1da1f2"];
    [self.messageButton setTitle:@"1条新消息" forState:UIControlStateNormal];
    self.messageButton.layer.masksToBounds = YES;
    self.messageButton.layer.cornerRadius = 5.0f;
    self.messageButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.classMomentUserButtonBlock,2);
    }];
    [self addSubview:self.messageButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"新消息"]];
    [self.messageButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageButton.mas_right);
        make.centerY.equalTo(self.messageButton.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d5d8db"];
    [self addSubview:self.lineView];
    
}
- (void)setupLayout {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(135.0f);
    }];
    
    [self.userHeaderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f, 80.0f));
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.top.equalTo(self.mas_top).offset(73.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userHeaderButton.mas_left).offset(-15.0f);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-15.0f);
        make.left.equalTo(self.mas_left).offset(15.0f);
    }];
    
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.userHeaderButton.mas_bottom).offset(32.0f);
        make.size.mas_offset(CGSizeMake(150.0f, 36.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.messageButton.mas_bottom).offset(15.0f);
        make.height.mas_offset(1.0f);
    }];
}

- (void)reload {
    [self.userHeaderButton sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"]];
    self.nameLabel.text = [UserManager sharedInstance].userModel.realName?:@"暂无";
}

@end
