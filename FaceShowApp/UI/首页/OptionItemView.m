//
//  OptionItemView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "OptionItemView.h"

@interface OptionItemView()
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *optionLabel;
@end

@implementation OptionItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e4e8eb"]] forState:UIControlStateHighlighted];
    [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e4e8eb"]] forState:UIControlStateSelected|UIControlStateHighlighted];
    [bgButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgButton];
    [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.bgButton = bgButton;
    
    self.selectImageView = [[UIImageView alloc]init];
    [self addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    self.optionLabel = [[UILabel alloc]init];
    self.optionLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.optionLabel.font = [UIFont systemFontOfSize:14];
    self.optionLabel.numberOfLines = 0;
    [self addSubview:self.optionLabel];
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(34);
        make.top.mas_equalTo(0);
        make.bottom.mas_lessThanOrEqualTo(0);
        make.right.mas_equalTo(self.selectImageView.mas_left).mas_offset(-14);
    }];
    
    self.editable = YES;
}

- (void)btnAction:(UIButton *)sender {
    [self updateWithSelectedStatus:!sender.selected];
    BLOCK_EXEC(self.clickBlock,self);
}

- (void)updateWithSelectedStatus:(BOOL)selected {
    self.bgButton.selected = selected;
    if (selected) {
        self.optionLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
        if (self.isMulti) {
            self.selectImageView.image = [UIImage imageNamed:@"多选已选择"];
        }else{
            self.selectImageView.image = [UIImage imageNamed:@"单选已选择"];
        }
    }else {
        self.optionLabel.textColor = [UIColor colorWithHexString:@"666666"];
        if (self.isMulti) {
            self.selectImageView.image = [UIImage imageNamed:@"多选未选择"];
        }else{
            self.selectImageView.image = [UIImage imageNamed:@"单选未选择"];
        }
    }
}

- (BOOL)isSelected {
    return self.bgButton.selected;
}

- (void)setIsSelected:(BOOL)isSelected {
    [self updateWithSelectedStatus:isSelected];
}

- (void)setOption:(NSString *)option {
    _option = option;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:option attributes:dic];
    self.optionLabel.attributedText = attributeStr;
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    self.selectImageView.hidden = !editable;
}

@end
