//
//  CertificateCell.m
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CertificateCell.h"
#import "MineCertiRequest.h"
@interface CertificateCell()
@property (nonatomic, strong) UIView *redPointView;
@property (nonatomic, strong) UIImageView *certiImageView;
@property (nonatomic, strong) UILabel *certiNameLabel;
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
    self.certiImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.certiImageView];
    [self.certiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];

    self.certiNameLabel = [[UILabel alloc] init];
    self.certiNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.certiNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.certiNameLabel];
    [self.certiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.certiImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(0);
    }];

    UIView *redPointView = [[UIView alloc] init];
    redPointView.layer.cornerRadius = 4.5f;
    redPointView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
    [self.contentView insertSubview:redPointView aboveSubview:self.certiImageView];
    [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.certiImageView).offset(3.5);
        make.top.mas_equalTo(self.certiImageView).offset(-3.5);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];
    self.redPointView = redPointView;
    [self.redPointView setHidden:YES];

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

- (void)setElements:(MineCertiRequest_Item_userCertList *)elements{
    _elements = elements;
    self.certiImageView.image = elements.certType.intValue == 1?[UIImage imageNamed:@"结节证书"]:[UIImage imageNamed:@"优秀学员证书"];
    self.certiNameLabel.text = elements.certType.intValue == 1?@"结业证书":@"优秀学员证书";
    [self.redPointView setHidden:elements.hasRead.intValue != 0];
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

- (void)setPointHidden{
    [self.redPointView setHidden:YES];
}

@end
