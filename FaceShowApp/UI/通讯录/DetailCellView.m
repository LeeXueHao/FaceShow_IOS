//
//  DetailCellView.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DetailCellView.h"

@interface DetailCellView ()
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation DetailCellView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.centerY.mas_equalTo(0);
        }];
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.contentLabel.textAlignment = NSTextAlignmentRight;
        self.contentLabel.text = content;
        self.contentLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickContentLabelAction)];
        [self.contentLabel addGestureRecognizer:tap];
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(titleLabel.mas_right).mas_offset(10);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        self.bottomLineView = [[UIView alloc] init];
        self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self addSubview:self.bottomLineView];
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setNeedBottomLine:(BOOL)needBottomLine {
    _needBottomLine = needBottomLine;
    self.bottomLineView.hidden = !needBottomLine;
}

-(void)clickContentLabelAction{
    BLOCK_EXEC(self.clickContentBlock,self.contentLabel.text);
}


@end
