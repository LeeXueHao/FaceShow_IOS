//
//  ResourceCell.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceCell.h"
#import "ResourceTypeMapping.h"

@interface ResourceCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ResourceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    
    self.iconImageView = [[UIImageView alloc] init];
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
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(-2);
        make.right.mas_equalTo(-15);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom).offset(2);
        make.right.mas_equalTo(-15);
    }];

    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downloadButton setImage:[UIImage imageNamed:@"聊聊-删除按钮正常态"] forState:UIControlStateNormal];
    [self.downloadButton setImage:[UIImage imageNamed:@"聊聊-删除按钮点击态"] forState:UIControlStateHighlighted];
    [self.downloadButton addTarget:self action:@selector(downloadBtnActiton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.downloadButton];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setElement:(GetResourceRequestItem_Element *)element {
    _element = element;
    self.iconImageView.image = [UIImage imageNamed:element.type.integerValue ? @"html" : [ResourceTypeMapping resourceTypeWithString:element.suffix]];
    self.titleLabel.text = element.resName;
    self.timeLabel.text = [element.createTime omitSecondOfFullDateString];
}

- (void) downloadBtnActiton{
    BLOCK_EXEC(self.downloadBlock,_element.resId);
}

@end
