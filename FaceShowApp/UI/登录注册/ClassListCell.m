//
//  ClassListCell.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassListCell.h"

@interface ClassListCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ClassListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.backView.backgroundColor = [UIColor colorWithHexString:selected ? @"0068bd" : @"ffffff"];
    self.nameLabel.textColor = [UIColor colorWithHexString:selected ? @"ffffff" : @"333333"];
    self.timeLabel.textColor = [UIColor colorWithHexString:selected ? @"ffffff" : @"999999"];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.minimumLineHeight = 21;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:isEmpty(self.classInfo.projectName) ? @"暂无" : self.classInfo.projectName
                                                                                      attributes:@{
                                                                                                                                                               NSParagraphStyleAttributeName : style,
                                                                                                                                                               NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                                                                                               NSForegroundColorAttributeName : [UIColor colorWithHexString:selected ? @"ffffff" : @"333333"]
                                                                                                                                                               }];
    self.titleLabel.attributedText = attributedStr;
}

#pragma mark - setupUI
- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *topBandView = [[UIView alloc] init];
    topBandView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:topBandView];
    [topBandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.bottom.mas_equalTo(-5);
        make.top.mas_equalTo(topBandView.mas_bottom).offset(5);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBandView.mas_bottom).offset(28);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(9);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(13);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
}

- (void)setClassInfo:(ClassListRequestItem_clazsInfos *)classInfo {
    _classInfo = classInfo;
    
    self.nameLabel.text = classInfo.clazsName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@", [classInfo.startTime componentsSeparatedByString:@" "].firstObject, [classInfo.endTime componentsSeparatedByString:@" "].firstObject];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.minimumLineHeight = 21;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:isEmpty(classInfo.projectName) ? @"暂无" : classInfo.projectName attributes:@{
                                                                                                                                                               NSParagraphStyleAttributeName : style,
                                                                                                                                                               NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                                                                                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]
                                                                                                                                                               }];
    self.titleLabel.attributedText = attributedStr;
}

@end
