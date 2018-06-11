//
//  ContactsCurrentClassView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsCurrentClassView.h"

@interface ContactsCurrentClassView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *selectedbutton;
@property(nonatomic, copy) ContactsClassStartFilterBlock block;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ContactsCurrentClassView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-30);
    }];
    
    self.selectedbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedbutton setImage:[UIImage imageNamed:@"下拉按钮正常态"] forState:UIControlStateNormal];
    [self.selectedbutton setImage:[UIImage imageNamed:@"下拉按钮点击态"] forState:UIControlStateHighlighted];
    [self addSubview:self.selectedbutton];
    [self.selectedbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterAction:)];
    [self addGestureRecognizer:tap];
}

- (void)filterAction:(UITapGestureRecognizer *)gesture {
    BLOCK_EXEC(self.block,self.title);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContactsClassStartFilterBlock:(ContactsClassStartFilterBlock)block {
    self.block = block;
}

- (void)setIsFiltering:(BOOL)isFiltering {
    _isFiltering = isFiltering;
    if (isFiltering) {
        [self.selectedbutton setImage:[UIImage imageNamed:@"收起按钮正常态"] forState:UIControlStateNormal];
        [self.selectedbutton setImage:[UIImage imageNamed:@"收起按钮点击态"] forState:UIControlStateHighlighted];
    }else {
        [self.selectedbutton setImage:[UIImage imageNamed:@"下拉按钮正常态"] forState:UIControlStateNormal];
        [self.selectedbutton setImage:[UIImage imageNamed:@"下拉按钮点击态"] forState:UIControlStateHighlighted];
    }
}
@end
