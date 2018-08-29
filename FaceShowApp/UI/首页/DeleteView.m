//
//  DeleteView.m
//  testtv
//
//  Created by niuzhaowang on 2018/8/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "DeleteView.h"
#import <Masonry.h>

@interface DeleteView()
@property (nonatomic, strong) UIView *firstHandView;
@property (nonatomic, strong) UIView *secondHandView;
@property (nonatomic, assign) BOOL deleteOpened;
@end

@implementation DeleteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"fc5236"];
    bgView.layer.cornerRadius = 10.5;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.firstHandView = [[UIView alloc]init];
    self.firstHandView.backgroundColor = [UIColor whiteColor];
    self.firstHandView.layer.cornerRadius = 1;
    self.firstHandView.clipsToBounds = YES;
    [self addSubview:self.firstHandView];
    [self.firstHandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(2);
    }];
    self.secondHandView = [[UIView alloc]init];
    self.secondHandView.backgroundColor = [UIColor whiteColor];
    self.secondHandView.layer.cornerRadius = 1;
    self.secondHandView.clipsToBounds = YES;
    [self addSubview:self.secondHandView];
    [self.secondHandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(2);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction {
    if (self.deleteOpened) {
        self.deleteBlock();
    }else {
        [UIView animateWithDuration:.3 animations:^{
            self.firstHandView.transform = CGAffineTransformMakeRotation(M_PI_4);
            self.secondHandView.transform = CGAffineTransformMakeRotation(M_PI_4*3);
        } completion:^(BOOL finished) {
            self.deleteOpened = YES;
        }];
    }
}

@end
