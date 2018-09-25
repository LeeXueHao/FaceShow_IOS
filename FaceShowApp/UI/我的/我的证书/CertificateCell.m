//
//  CertificateCell.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CertificateCell.h"

@implementation CertificateCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    self.contentView.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"结业证书";
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(15);
        make.centerY.mas_equalTo(0);
    }];

    
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
