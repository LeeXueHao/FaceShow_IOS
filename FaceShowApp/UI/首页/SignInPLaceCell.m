//
//  SignInPLaceCell.m
//  FaceShowApp
//
//  Created by ZLL on 2018/5/31.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInPLaceCell.h"

@interface SignInPLaceCell()
@property (nonatomic, strong) UIButton *signInBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeTipLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) SignInPlaceBlock block;
@end

@implementation SignInPLaceCell

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

#pragma mark - setupUI
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-65);
    }];
    
    self.timeTipLabel = [self generateTagLabelWithText:@"时间"];
    [self.contentView addSubview:self.timeTipLabel];
    [self.timeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(33, 15));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeTipLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.timeTipLabel);
        make.right.mas_equalTo(-65);
    }];

    self.signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signInBtn setBackgroundImage:[UIImage imageNamed:@"签到"] forState:UIControlStateNormal];
    self.signInBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.signInBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.signInBtn setTitle:@"签到" forState:UIControlStateNormal];
    [self.signInBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    WEAK_SELF
    [[self.signInBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.block);
    }];
    [self.contentView addSubview:self.signInBtn];
    [self.signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 50));
    }];

    self.placeLabel = [[UILabel alloc] init];
    self.placeLabel.font = [UIFont systemFontOfSize:13];
    self.placeLabel.numberOfLines = 0;
    self.placeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
}

- (void)setData:(GetSignInRecordListRequestItem_SignIn *)data {
    self.titleLabel.text = data.title;
    NSString *endTime = [data.endTime omitSecondOfFullDateString];
    endTime = [endTime componentsSeparatedByString:@" "].lastObject;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[data.startTime omitSecondOfFullDateString],endTime];

    __block MASViewAttribute *bottom = self.timeLabel.mas_bottom;
    [data.signInExts enumerateObjectsUsingBlock:^(GetSignInRequest_Item_signInExts  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *tag = [self generateTagLabelWithText:@"地点"];
        [self.contentView addSubview:tag];
        [tag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeTipLabel);
            make.top.mas_equalTo(bottom).mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(33, 15));
        }];

        UILabel *placeLabel = [self.placeLabel clone];
        [placeLabel setText:obj.positionSite];
        [self.contentView addSubview:placeLabel];
        [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel);
            make.centerY.mas_equalTo(tag);
            make.right.mas_equalTo(self.signInBtn.mas_left).offset(-10);
            if (idx == data.signInExts.count - 1) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            }
        }];
        bottom = placeLabel.mas_bottom;
    }];

}

- (void)setSignInPlaceBlock:(SignInPlaceBlock)block {
    self.block = block;
}

- (UILabel *)generateTagLabelWithText:(NSString *)text{
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.font = [UIFont systemFontOfSize:11];
    tagLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    tagLabel.layer.backgroundColor = [UIColor colorWithHexString:@"a6b0bf"].CGColor;
    tagLabel.layer.cornerRadius = 3.f;
    tagLabel.text = text;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    return tagLabel;
}
@end
