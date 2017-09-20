//
//  CourseCatalogCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCatalogCell.h"

@interface CourseCatalogCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CourseCatalogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIconUrl:(NSString *)iconUrl {
    _iconUrl = iconUrl;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@""]];
}

@end
