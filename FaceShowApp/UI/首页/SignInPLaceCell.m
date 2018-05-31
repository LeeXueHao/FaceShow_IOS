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
@property (nonatomic, strong) UILabel *placeTipLabel;
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
        [self setupMockData];
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
    }];
    
    self.timeTipLabel = [[UILabel alloc] init];
    self.timeTipLabel.font = [UIFont systemFontOfSize:11];
    self.timeTipLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.timeTipLabel.text = @"时间";
    self.timeTipLabel.textAlignment = NSTextAlignmentCenter;
    self.timeTipLabel.layer.backgroundColor = [UIColor colorWithHexString:@"a6b0bf"].CGColor;
    self.timeTipLabel.layer.cornerRadius = 3.f;
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
        make.right.mas_equalTo(-15);
    }];
    
    self.placeTipLabel = [[UILabel alloc] init];
    self.placeTipLabel.font = [UIFont systemFontOfSize:11];
    self.placeTipLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.placeTipLabel.layer.backgroundColor = [UIColor colorWithHexString:@"a6b0bf"].CGColor;
    self.placeTipLabel.layer.cornerRadius = 3.f;
    self.placeTipLabel.text = @"地点";
    self.placeTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.placeTipLabel];
    [self.placeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeTipLabel);
        make.top.mas_equalTo(self.timeTipLabel.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(33, 15));
    }];
    
    self.placeLabel = [[UILabel alloc] init];
    self.placeLabel.font = [UIFont systemFontOfSize:13];
    self.placeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel);
        make.centerY.mas_equalTo(self.placeTipLabel);
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
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
}

- (void)setupMockData {
    self.titleLabel.text = @"这是标题了啦";
    self.timeLabel.text = @"2018-06-01 8:00-10:00";
    self.placeLabel.text = @"北京西城区北广大厦";
}

- (void)setSignInPlaceBlock:(SignInPlaceBlock)block {
    self.block = block;
}
@end
