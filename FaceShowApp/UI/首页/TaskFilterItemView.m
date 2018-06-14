//
//  TaskFilterItemView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskFilterItemView.h"

@implementation TaskFilterItem
@end

@interface TaskFilterItemView()
@property(nonatomic, strong) UIButton *taskButton;
@end

@implementation TaskFilterItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.taskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    WEAK_SELF
    [[self.taskButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.taskFilterItemChooseBlock,self.item);
    }];
    [self addSubview:self.taskButton];
    [self.taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setItem:(TaskFilterItem *)item {
    _item = item;
    [self.taskButton setTitle:[NSString stringWithFormat:@"%@(%@/%@)",item.title,@(item.finishedTask),@(item.totalTask)] forState:UIControlStateNormal];
}
@end
