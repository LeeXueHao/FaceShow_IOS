//
//  CertificateCell.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CertificateCell.h"

@interface CertificateCell()
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation CertificateCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];

    int i = arc4random()%2;

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = i?[UIImage imageNamed:@"结节证书"]:[UIImage imageNamed:@"优秀学员证书"];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];

    UILabel *label = [[UILabel alloc] init];
    label.text = i ? @"结业证书":@"优秀学员证书";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(15);
        make.centerY.mas_equalTo(0);
    }];

    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进入页面按钮正常态"] highlightedImage:[UIImage imageNamed:@"进入页面按钮点击态"]];
    [self.contentView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"ced3d6"];
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setIsLastRow:(BOOL)isLastRow{
    _isLastRow = isLastRow;
    self.bottomLine.hidden = isLastRow;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
