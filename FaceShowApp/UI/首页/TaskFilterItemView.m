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
@property (nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *completionLabel;
@end

@implementation TaskFilterItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconImageView = [[UIImageView alloc] init];
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(0);
    }];
    
    self.completionLabel = [[UILabel alloc]init];
    self.completionLabel.font = [UIFont systemFontOfSize:14];
    self.completionLabel.textColor = [UIColor colorWithHexString:@"a2a6a9"];
    [self addSubview:self.completionLabel];
    [self.completionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.centerX.mas_equalTo(0);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.isSelected = YES;
        BLOCK_EXEC(self.taskFilterItemChooseBlock,self.item);
    }];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.iconImageView.highlighted = YES;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
        self.completionLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    }else {
        self.iconImageView.highlighted = NO;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.completionLabel.textColor = [UIColor colorWithHexString:@"a2a6a9"];
    }
}

- (void)setItem:(TaskFilterItem *)item {
    _item = item;
    self.iconImageView.image = [UIImage imageNamed:item.title];
    self.titleLabel.text = item.title;
    self.completionLabel.text = [NSString stringWithFormat:@"%@/%@",@(item.finishedTask),@(item.totalTask)];
}
@end
