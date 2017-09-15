//
//  MineDefaultCell.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineDefaultCell.h"
@interface MineDefaultCell ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *nextImageView;
@end
@implementation MineDefaultCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setContenDictionary:(NSDictionary *)contenDictionary {
    _contenDictionary = contenDictionary;
    self.titleLabel.text = _contenDictionary[@"title"];
    self.logoImageView.image = [UIImage imageNamed:_contenDictionary[@"image"]];
}
#pragma mark - setupUI 
- (void)setupUI {
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.logoImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    
    self.nextImageView = [[UIImageView alloc] init];
    self.nextImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.nextImageView];
}
- (void)setupLayout {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(5.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        self.nextImageView.image = [UIImage imageNamed:@"wei"];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.nextImageView.image = [UIImage imageNamed:@"dianji"];
    }
    else{
        self.nextImageView.image = [UIImage imageNamed:@"wei"];
    }
}


@end
