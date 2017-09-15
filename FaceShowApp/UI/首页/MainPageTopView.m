//
//  MainPageTopView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageTopView.h"

@interface MainPageTopView()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *projectLabel;
@property (nonatomic, strong) UILabel *classLabel;
@end

@implementation MainPageTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.image = [UIImage imageWithColor:[UIColor blueColor]];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.projectLabel = [[UILabel alloc]init];
    self.projectLabel.textColor = [UIColor whiteColor];
    self.projectLabel.font = [UIFont systemFontOfSize:15];
    self.projectLabel.textAlignment = NSTextAlignmentCenter;
    self.projectLabel.numberOfLines = 2;
    [self addSubview:self.projectLabel];
    [self.projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
    }];
    self.classLabel = [[UILabel alloc]init];
    self.classLabel.textColor = [UIColor whiteColor];
    self.classLabel.font = [UIFont systemFontOfSize:15];
    self.classLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.classLabel];
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.projectLabel.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    [self initData];
}

- (void)initData {
    self.projectLabel.text = @"国培计划-专职培训团队研修-这是第一个项目啦啦啦啦啦啦啦啦啦";
    self.classLabel.text = @"一年级二班";
    if (self.classLabel.text.length == 0) {
        [self.projectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
        }];
        [self.classLabel removeFromSuperview];
    }
}

@end
