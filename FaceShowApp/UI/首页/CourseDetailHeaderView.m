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
    titleLabel.text = @"课 l 程 l 详 l 情";
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
    
    UILabel *timeTagLabel = [[UILabel alloc]init];
    timeTagLabel.font = [UIFont systemFontOfSize:11];
    timeTagLabel.textColor = [UIColor whiteColor];
    timeTagLabel.textAlignment = NSTextAlignmentCenter;
    timeTagLabel.backgroundColor = [UIColor colorWithHexString:@"979fad"];
    timeTagLabel.text = @"时间";
    timeTagLabel.layer.cornerRadius = 3;
    timeTagLabel.clipsToBounds = YES;
    [self addSubview:timeTagLabel];
    [timeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.courseTitleLabel.mas_bottom).mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeTagLabel.mas_right).offset(7);
        make.centerY.mas_equalTo(timeTagLabel.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *teacherTagLabel = [timeTagLabel clone];
    teacherTagLabel.text = @"专家";
    [self addSubview:teacherTagLabel];
    [teacherTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeTagLabel.mas_left);
        make.top.mas_equalTo(timeTagLabel.mas_bottom).mas_offset(9);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    
    self.authorLabel = [self.timeLabel clone];
    [self addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teacherTagLabel.mas_right).offset(7);
        make.centerY.mas_equalTo(teacherTagLabel.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *placeTagLabel = [timeTagLabel clone];
    placeTagLabel.text = @"地点";
    [self addSubview:placeTagLabel];
    [placeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teacherTagLabel.mas_left);
        make.top.mas_equalTo(teacherTagLabel.mas_bottom).mas_offset(9);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    
    self.addressLabel = [self.timeLabel clone];
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(placeTagLabel.mas_right).offset(7);
        make.centerY.mas_equalTo(placeTagLabel.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *middleBandView = [[UIView alloc] init];
    middleBandView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:middleBandView];
    [middleBandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(24);
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
        make.top.mas_equalTo(briefTitleLabel.mas_bottom).offset(12);
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
        make.top.mas_equalTo(contentsTitleLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)viewAllBtnAction:(UIButton *)sender {
    BLOCK_EXEC(self.viewAllBlock);
}

- (void)setCourse:(GetCourseRequestItem_Course *)course {
    _course = course;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 24;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:course.courseName attributes:@{
                                                                                                                  NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                                                                                                  NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                                                                  NSParagraphStyleAttributeName : style
                                                                                                                  }];
    self.courseTitleLabel.attributedText = attributedStr;
    self.timeLabel.text = [course.startTime omitSecondOfFullDateString];
    self.authorLabel.text = isEmpty([self lecturesName]) ? @"暂无" : [self lecturesName];
    self.addressLabel.text = isEmpty(course.site) ? @"待定" : course.site;
    
    style.minimumLineHeight = 21;
    attributedStr = [[NSMutableAttributedString alloc] initWithString:isEmpty(course.briefing) ? @"暂无" : course.briefing attributes:@{
                                                                                      NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                      NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                                      NSParagraphStyleAttributeName : style
                                                                                      }];
    self.briefLabel.attributedText = attributedStr;
    
    CGSize size = [self.briefLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)];
    if (size.height > 105) {
        self.viewAllBtn.hidden = NO;
        [self.briefLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(105);
        }];
        [self.bottomBandView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.viewAllBtn.mas_bottom).offset(20);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
    }
}

- (NSString *)lecturesName {
    NSMutableString *lecturesName = [NSMutableString string];
    for (GetCourseRequestItem_LecturerInfo *info in self.course.lecturerInfos) {
        if (!isEmpty(lecturesName)) {
            [lecturesName appendString:@","];
        }
        [lecturesName appendString:[NSString stringWithFormat:@"%@",  info.lecturerName]];
    }
    return lecturesName;
}

+ (CGFloat)heightForCourse:(GetCourseRequestItem_Course *)course {
    CourseDetailHeaderView *view = [[CourseDetailHeaderView alloc]init];
    view.course = course;
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SCREEN_WIDTH];
    [view addConstraint:widthFenceConstraint];
    // Auto layout engine does its math
    CGSize fittingSize = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [view removeConstraint:widthFenceConstraint];
    return ceil(fittingSize.height);
}

@end
