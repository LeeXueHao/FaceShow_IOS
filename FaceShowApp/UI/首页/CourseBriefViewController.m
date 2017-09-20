//
//  CourseBriefViewController.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseBriefViewController.h"

@interface CourseBriefViewController ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation CourseBriefViewController

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
    self.title = @"课程简介";
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(25);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-25);
    }];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 23;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.courseBrief attributes:@{
                                                                                                                  NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                                                                  NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                                                                  NSParagraphStyleAttributeName : style
                                                                                                                  }];
    self.contentLabel.attributedText = attributedStr;
}

@end
