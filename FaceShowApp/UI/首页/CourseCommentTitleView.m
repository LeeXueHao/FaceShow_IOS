//
//  CourseCommentTitleView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentTitleView.h"

@interface CourseCommentTitleView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CourseCommentTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"课程讨论的问题图标"];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.numberOfLines = 0;
    [bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(43);
        make.bottom.mas_equalTo(-43);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(imageView.mas_right).mas_offset(7);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:title attributes:dic];
    self.titleLabel.attributedText = attributeStr;
}

+ (CGFloat)heightForTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:title attributes:dic];
    label.attributedText = attributeStr;
    CGSize size = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH-5-50-7-15, CGFLOAT_MAX)];
    return size.height+43+43+5;
}

@end
