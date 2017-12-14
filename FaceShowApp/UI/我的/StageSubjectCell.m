//
//  StageSubjectCell.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StageSubjectCell.h"

@interface StageSubjectCell ()
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation StageSubjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选择按钮"]];
    [self.contentView addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(19, 15));
    }];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setIsLastRow:(BOOL)isLastRow {
    _isLastRow = isLastRow;
    self.bottomLine.hidden = isLastRow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedImageView.hidden = !selected;
    self.textLabel.textColor = [UIColor colorWithHexString:selected ? @"1da1f2" : @"333333"];
}

@end
