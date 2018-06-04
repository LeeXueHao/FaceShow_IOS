//
//  ContactsClassFilterCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsClassFilterCell.h"
#import <NSString+HTML.h>

@interface ContactsClassFilterCell ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation ContactsClassFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-30);
    }];
    
    self.selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选择图标"]];
    [self.contentView addSubview:self.selectedImageView];
    self.selectedImageView.hidden = YES;
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
    
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setIsChoosed:(BOOL)isChoosed {
    _isChoosed = isChoosed;
    if (isChoosed) {
        self.selectedImageView.hidden = NO;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }else {
        self.selectedImageView.hidden = YES;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
}
@end
