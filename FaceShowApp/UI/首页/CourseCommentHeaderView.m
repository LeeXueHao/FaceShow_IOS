//
//  CourseCommentHeaderView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentHeaderView.h"

@interface CourseCommentHeaderView()

@end

@implementation CourseCommentHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
//    self.titleLabel = [[UILabel alloc]init];
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
//    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
//    [self addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.bottom.mas_equalTo(2.0f);
//    }];
}

@end
