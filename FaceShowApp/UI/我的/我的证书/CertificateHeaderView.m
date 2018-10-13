//
//  CertificateHeaderView.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CertificateHeaderView.h"
#import "MineCertiRequest.h"
@interface CertificateHeaderView()
@property (nonatomic, strong) UILabel *projectLabel;
@property (nonatomic, strong) UILabel *classLabel;
@end

@implementation CertificateHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    self.backgroundColor = [UIColor whiteColor];

    self.projectLabel = [[UILabel alloc] init];
    self.projectLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.projectLabel.font = [UIFont boldSystemFontOfSize:13];
    self.projectLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.projectLabel];
    [self.projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
    }];

    self.classLabel = [[UILabel alloc] init];
    [self addSubview:self.classLabel];
    self.classLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.classLabel.font = [UIFont systemFontOfSize:12];
    self.classLabel.textAlignment = NSTextAlignmentLeft;
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-5);
    }];

}

- (void)setCertList:(MineCertiRequest_Item_clazsCertList *)certList{
    _certList = certList;
    [self.projectLabel setText:certList.projectName];
    [self.classLabel setText:certList.clazsName];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
