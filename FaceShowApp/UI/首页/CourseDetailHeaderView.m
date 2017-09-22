//
//  CourseDetailHeaderView.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseDetailHeaderView.h"
#import "GetCourseRequest.h"

@interface CourseDetailHeaderView ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *courseTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *middleLineView;
@property (nonatomic, strong) UILabel *briefLabel;
@property (nonatomic, strong) UIButton *viewAllBtn;
@property (nonatomic, strong) UIView *bottomBandView;

@end

@implementation CourseDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.image = [UIImage imageNamed:@"课程详情头图"];
    [self addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(135);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:21];
    titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    titleLabel.text = @"课l程l详l情";
    [self.headerImageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-45);
        make.centerX.mas_equalTo(0);
    }];
    
    self.courseTitleLabel = [[UILabel alloc] init];
    self.courseTitleLabel.numberOfLines = 0;
    [self addSubview:self.courseTitleLabel];
    [self.courseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    UIImageView *timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"课程详情时间"]];
    [self addSubview:timeIcon];
    [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.courseTitleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeIcon.mas_right).offset(7);
        make.centerY.mas_equalTo(timeIcon.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    UIImageView *authorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"课程详情专家"]];
    [self addSubview:authorIcon];
    [authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(timeIcon.mas_bottom).offset(1.5f);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    self.authorLabel = [self.timeLabel clone];
    [self addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(authorIcon.mas_right).offset(7);
        make.centerY.mas_equalTo(authorIcon.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    UIImageView *addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"课程详情地点"]];
    [self addSubview:addressIcon];
    [addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(authorIcon.mas_bottom).offset(1.5f);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    self.addressLabel = [self.timeLabel clone];
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressIcon.mas_right).offset(7);
        make.centerY.mas_equalTo(addressIcon.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *middleBandView = [[UIView alloc] init];
    middleBandView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:middleBandView];
    [middleBandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(26);
        make.height.mas_equalTo(5);
    }];
    
    UILabel *briefTitleLabel = [[UILabel alloc] init];
    briefTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    briefTitleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    briefTitleLabel.text = @"课程简介";
    [self addSubview:briefTitleLabel];
    [briefTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(middleBandView.mas_bottom).offset(21.5f);
    }];
    
    self.middleLineView = [middleBandView clone];
    [self addSubview:self.middleLineView];
    [self.middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(middleBandView.mas_bottom).offset(43);
        make.height.mas_equalTo(1);
    }];
    
    self.briefLabel = [[UILabel alloc] init];
    self.briefLabel.numberOfLines = 0;
    [self addSubview:self.briefLabel];
    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.middleLineView.mas_bottom).offset(15);
        make.right.mas_equalTo(-15);
    }];
    
    self.viewAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.viewAllBtn.clipsToBounds = YES;
    self.viewAllBtn.layer.cornerRadius = 7;
    self.viewAllBtn.layer.borderColor = [UIColor colorWithHexString:@"1da1f2"].CGColor;
    self.viewAllBtn.layer.borderWidth = 2;
    [self.viewAllBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.viewAllBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
    [self.viewAllBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [self.viewAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.viewAllBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [self.viewAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [self.viewAllBtn addTarget:self action:@selector(viewAllBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.viewAllBtn.hidden = YES;
    [self addSubview:self.viewAllBtn];
    [self.viewAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.briefLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(85, 31));
    }];

    self.bottomBandView = [middleBandView clone];
    [self addSubview:self.bottomBandView];
    [self.bottomBandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.briefLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(5);
    }];
    
    UILabel *contentsTitleLabel = [briefTitleLabel clone];
    contentsTitleLabel.text = @"课程目录";
    [self addSubview:contentsTitleLabel];
    [contentsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.bottomBandView.mas_bottom).offset(21.5f);
    }];
    
    UIView *bottomLineView = [self.middleLineView clone];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.bottomBandView.mas_bottom).offset(43);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)viewAllBtnAction:(UIButton *)sender {
    BLOCK_EXEC(self.viewAllBlock);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.briefLabel.bounds.size.height > 105) {
        self.viewAllBtn.hidden = NO;
        [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.middleLineView.mas_bottom).offset(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(105);
        }];
        [self.bottomBandView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.viewAllBtn.mas_bottom).offset(20);
            make.height.mas_equalTo(5);
        }];
        [self.superview layoutIfNeeded];
    }
}

- (void)setCourse:(GetCourseRequestItem_Course *)course {
    _course = course;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 24;
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:course.courseName attributes:@{
                                                                                                                  NSFontAttributeName : [UIFont systemFontOfSize:18],
                                                                                                                  NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                                                                  NSParagraphStyleAttributeName : style
                                                                                                                  }];
    self.courseTitleLabel.attributedText = attributedStr;
    self.timeLabel.text = course.startTime;
    self.authorLabel.text = course.lecturer;
    self.addressLabel.text = course.site;
    
    style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.minimumLineHeight = 21;
    attributedStr = [[NSMutableAttributedString alloc] initWithString:course.briefing attributes:@{
                                                                                      NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                      NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                                      NSParagraphStyleAttributeName : style
                                                                                      }];
    self.briefLabel.attributedText = attributedStr;
}

@end
