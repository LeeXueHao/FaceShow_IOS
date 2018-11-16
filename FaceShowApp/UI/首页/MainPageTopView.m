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
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *projectLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *group;
@property (nonatomic, strong) UILabel *groupLabel;
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
    self.bgImageView.image = [UIImage imageNamed:@"首页背景"];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页班级图标"]];
    [self addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];

    UILabel *project = [[UILabel alloc] init];
    project.text = @"项目";
    project.layer.masksToBounds = YES;
    project.layer.cornerRadius = 3.0f;
    project.textAlignment = NSTextAlignmentCenter;
    project.font = [UIFont systemFontOfSize:8];
    project.textColor = [UIColor colorWithHexString:@"333333"];
    project.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
    [self addSubview:project];
    CGSize size = [@"项目" sizeWithFont:[UIFont systemFontOfSize:8]];
    [project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(leftImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width + 4, size.height));
    }];

    self.projectLabel = [[UILabel alloc]init];
    self.projectLabel.textColor = [UIColor whiteColor];
    self.projectLabel.numberOfLines = 2;
    self.projectLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.projectLabel];
    [self.projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(project.mas_right).offset(2);
        make.right.mas_lessThanOrEqualTo(-30);
    }];

    [project mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.projectLabel.mas_top).offset(2);
        make.left.mas_equalTo(leftImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width + 4, size.height));
    }];


    UILabel *class = [[UILabel alloc] init];
    class.text = @"班级";
    class.layer.masksToBounds = YES;
    class.layer.cornerRadius = 3.0f;
    class.textAlignment = NSTextAlignmentCenter;
    class.font = [UIFont systemFontOfSize:10];
    class.textColor = [UIColor colorWithHexString:@"333333"];
    class.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
    [self addSubview:class];
    size = [@"班级" sizeWithFont:[UIFont systemFontOfSize:10]];
    [class mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftImageView.mas_top).offset(2);
        make.left.mas_equalTo(project);
        make.size.mas_equalTo(CGSizeMake(size.width + 4, size.height));
    }];

    self.classLabel = [[UILabel alloc]init];
    self.classLabel.textColor = [UIColor whiteColor];
    self.classLabel.numberOfLines = 2;
    self.classLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.classLabel];
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_lessThanOrEqualTo(self.projectLabel.mas_top).offset(-5);
        make.left.mas_equalTo(self.projectLabel.mas_left).offset(5);
        make.right.mas_lessThanOrEqualTo(-20);
    }];

    [class mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classLabel.mas_top).offset(3);
        make.left.mas_equalTo(project);
        make.size.mas_equalTo(CGSizeMake(size.width + 4, size.height));
    }];

    self.group = [project clone];
    [self.group setText:@"小组"];
    self.group.layer.masksToBounds = YES;
    self.group.layer.cornerRadius = 3.0f;
    [self addSubview:self.group];
    size = [@"班级" sizeWithFont:[UIFont systemFontOfSize:8]];
    [self.group mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(leftImageView.mas_bottom).offset(-2);
        make.left.mas_equalTo(project);
        make.size.mas_equalTo(CGSizeMake(size.width + 4, size.height));
    }];

    self.groupLabel = [self.projectLabel clone];
    [self addSubview:self.groupLabel];
    [self.groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(self.projectLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.projectLabel.mas_left);
        make.right.mas_lessThanOrEqualTo(-30);
    }];

    [self.group mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groupLabel.mas_top).offset(2);
        make.left.mas_equalTo(project);
        make.size.mas_equalTo(CGSizeMake(size.width + 4, size.height));
    }];

    self.groupLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    WEAK_SELF
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        GetCurrentClazsRequestItem_userGroup *groupData = self->_item.data.userGroups.firstObject;
        BLOCK_EXEC(self.clickGroupBlock,groupData);
    }];
    [self.groupLabel addGestureRecognizer:tap];

    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    containerView.layer.masksToBounds = YES;
    containerView.layer.cornerRadius = 6.0f;
    [self insertSubview:containerView belowSubview:leftImageView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_lessThanOrEqualTo(leftImageView.mas_top).offset(-22);
        make.top.mas_lessThanOrEqualTo(self.classLabel.mas_top).offset(-15);
        make.bottom.mas_greaterThanOrEqualTo(leftImageView.mas_bottom).offset(15);
        make.bottom.mas_greaterThanOrEqualTo(self.groupLabel.mas_bottom).offset(11);
    }];
    self.container = containerView;

}

- (void)setItem:(GetCurrentClazsRequestItem *)item {
    _item = item;
    self.projectLabel.text = [NSString stringWithFormat:@"%@",item.data.projectInfo.projectName];
    self.classLabel.text = [NSString stringWithFormat:@"%@",item.data.clazsInfo.clazsName];
    if (item.data.userGroups.firstObject) {
        GetCurrentClazsRequestItem_userGroup *groupData = item.data.userGroups.firstObject;
        [self.group setHidden:NO];
        self.groupLabel.text = [NSString stringWithFormat:@"%@",groupData.groupName];
    }else{
        [self.group setHidden:YES];
    }
    [self.container setNeedsLayout];
}

@end
