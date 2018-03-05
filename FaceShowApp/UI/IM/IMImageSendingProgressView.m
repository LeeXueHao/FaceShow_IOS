//
//  IMImageSendingProgressView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMImageSendingProgressView.h"

@implementation IMImageSendingProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [[UIColor colorWithHexString:@"ECECEC"] colorWithAlphaComponent:0.8];
    
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setupLayout {
    [self addSubview:self.activity];
    [self addSubview:self.progressLabel];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activity.mas_bottom).offset(15);
        make.centerX.mas_equalTo(0);
    }];
}
@end
