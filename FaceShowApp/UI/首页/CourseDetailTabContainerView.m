//
//  CourseDetailTabContainerView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseDetailTabContainerView.h"

@interface CourseDetailTabContainerView()
@property (nonatomic, strong) NSMutableArray *tabButtonArray;
@property (nonatomic, strong) UIView *sliderView;
@end

@implementation CourseDetailTabContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setTabNameArray:(NSArray *)tabNameArray {
    _tabNameArray = tabNameArray;
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    self.tabButtonArray = [NSMutableArray array];
    CGFloat tabWidth = SCREEN_WIDTH/tabNameArray.count;
    [tabNameArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = [[UIButton alloc]init];
        [b setTitle:obj forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
        b.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(tabWidth*idx);
            make.width.mas_equalTo(tabWidth);
        }];
        [self.tabButtonArray addObject:b];
        if (idx == 0) {
            b.selected = YES;
        }
    }];
    self.sliderView = [[UIView alloc]init];
    self.sliderView.backgroundColor = [UIColor colorWithHexString:@"0068bd"];
    [self addSubview:self.sliderView];
    UIButton *b = self.tabButtonArray.firstObject;
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(b.mas_centerX);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(130);
    }];
}

- (void)btnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *b in self.tabButtonArray) {
        b.selected = NO;
    }
    sender.selected = YES;
    //    CGFloat tabWidth = SCREEN_WIDTH/self.tabNameArray.count;
    NSInteger index = [self.tabButtonArray indexOfObject:sender];
    [UIView animateWithDuration:.2 animations:^{
        [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(sender.mas_centerX);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(130);
        }];
        [self layoutIfNeeded];
    }];
    BLOCK_EXEC(self.tabClickBlock,index);
}

@end
