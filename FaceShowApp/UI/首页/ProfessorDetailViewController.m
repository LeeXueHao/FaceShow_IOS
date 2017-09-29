//
//  ProfessorDetailViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProfessorDetailViewController.h"
#import "GetCourseRequest.h"

@interface ProfessorDetailViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *introductionLabel;

@end

@implementation ProfessorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.title = @"专家介绍";
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.image = [UIImage imageNamed:@"背景图片"];
    [self.contentView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(135);
    }];
    
    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    shadowView.layer.cornerRadius = 5;
    shadowView.layer.shadowOffset = CGSizeMake(0, 1);
    shadowView.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    shadowView.layer.shadowOpacity = .2f;
    [self.contentView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(75);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.layer.cornerRadius = 5;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeCenter;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.lecturerInfo.lecturerAvatar] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"]];
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(75);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.text = self.lecturerInfo.lecturerName;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(21);
        make.centerX.mas_equalTo(0);
    }];
    
    self.introductionLabel = [[UILabel alloc] init];
    self.introductionLabel.numberOfLines = 0;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 23;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.lecturerInfo.lecturerBriefing attributes:@{
                                                                                                                                                 NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                                                                                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                                                                                                 NSParagraphStyleAttributeName : style
                                                                                                                                                 }];
    self.introductionLabel.attributedText = attributedStr;
    [self.contentView addSubview:self.introductionLabel];
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(-15);
    }];
}

@end
