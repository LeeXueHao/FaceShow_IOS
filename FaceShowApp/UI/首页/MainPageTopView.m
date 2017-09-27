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
    self.bgImageView.image = [UIImage imageNamed:@"背景图片-首页"];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIView *topView = [[UIView alloc]init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 24));
    }];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = CGRectMake(0, 0, 60, 24);
    layer.fillColor = [[UIColor blackColor]colorWithAlphaComponent:0.3].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:layer.frame byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    layer.path = path.CGPath;
    [topView.layer addSublayer:layer];
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.font = [UIFont systemFontOfSize:10];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.text = @"当前项目";
    [topView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.classLabel = [[UILabel alloc]init];
    self.classLabel.textColor = [UIColor whiteColor];
    self.classLabel.font = [UIFont boldSystemFontOfSize:13];
    self.classLabel.textAlignment = NSTextAlignmentCenter;
    self.classLabel.layer.cornerRadius = 6;
    self.classLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.classLabel.layer.borderWidth = 1;
    [self addSubview:self.classLabel];
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(67);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(26);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    self.projectLabel = [[UILabel alloc]init];
    self.projectLabel.textColor = [UIColor whiteColor];
    self.projectLabel.font = [UIFont boldSystemFontOfSize:18];
    self.projectLabel.textAlignment = NSTextAlignmentCenter;
    self.projectLabel.numberOfLines = 2;
    [self addSubview:self.projectLabel];
    [self.projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(self.classLabel.mas_top);
    }];
}

- (void)setItem:(GetCurrentClazsRequestItem *)item {
    _item = item;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    paraStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSString *project = item.data.projectInfo.projectName;
    NSAttributedString *projectAttributeStr = [[NSAttributedString alloc] initWithString:project attributes:dic];
    self.projectLabel.attributedText = projectAttributeStr;
    
    self.classLabel.text = item.data.clazsInfo.clazsName;
    [self.classLabel sizeToFit];
    [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.classLabel.width+20);
    }];
    if (self.classLabel.text.length == 0) {
        self.classLabel.hidden = YES;
    }
}

@end
