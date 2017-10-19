//
//  UserInfoDefaultCell.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoDefaultCell.h"
@interface UserInfoDefaultCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *nextImageView;
@end
@implementation UserInfoDefaultCell
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
    self.contentLabel.text = _contenDictionary[@"content"];
    id next = [contenDictionary valueForKey:@"next"];
    if (next) {
        self.nextImageView.hidden = NO;        
        [self.nextImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-5.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.nextImageView.mas_left).offset(-5.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(15.0f);
        }];
    }else {
        self.nextImageView.hidden = YES;
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(15.0f);
        }];
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.contentLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
    
    self.nextImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.nextImageView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f).priorityHigh();
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(15.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_offset(1.0f);
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
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮点击态"];
    }
    else{
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    }
}

@end
