//
//  FDActionSheetFooterView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FDActionSheetFooterView.h"

@implementation FDActionSheetFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        self.backgroundView = view;
        
        self.contentView.backgroundColor = [UIColor clearColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"1da1f2"]] forState:UIControlStateHighlighted];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        WEAK_SELF
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF
            BLOCK_EXEC(self.actionSheetCancleBlock);
        }];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top).offset(5.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

@end
