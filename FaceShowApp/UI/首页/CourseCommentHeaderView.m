//
//  CourseCommentHeaderView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentHeaderView.h"

@interface CourseCommentHeaderView()
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation CourseCommentHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setCountStr:(NSString *)countStr {
    _countStr = countStr;
    self.countLabel.text = [NSString stringWithFormat:@"回复 (%@)",countStr? :@""];
}

@end
