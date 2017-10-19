
//
//  SexItemView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SexItemView.h"

@interface SexItemView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectionImageView;
@end

@implementation SexItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.selectionImageView = [[UIImageView alloc]init];
    self.selectionImageView.image = [UIImage imageNamed:@"单选已选择"];
    [self addSubview:self.selectionImageView];
    [self.selectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    UIButton *b = [[UIButton alloc]init];
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)btnAction:(UIButton *)sender {
    if (self.selected) {
        return;
    }
    BLOCK_EXEC(self.selectionBlock);
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.selectionImageView.hidden = !selected;
}

@end
