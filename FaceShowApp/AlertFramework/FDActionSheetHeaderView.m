//
//  FDActionSheetHeaderView.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FDActionSheetHeaderView.h"

@interface FDActionSheetHeaderView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation FDActionSheetHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        self.backgroundView = view;
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.textColor = [UIColor colorWithHexString:@"999999"];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
}

@end
