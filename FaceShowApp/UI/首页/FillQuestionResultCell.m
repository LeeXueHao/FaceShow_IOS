//
//  FillQuestionResultCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FillQuestionResultCell.h"

@interface FillQuestionResultCell()
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *stemLabel;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *attendLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UITextView *replyTextView;
@end

@implementation FillQuestionResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.indexLabel = [[UILabel alloc]init];
    self.indexLabel.font = [UIFont boldSystemFontOfSize:14];
    self.indexLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(25);
    }];
    
    self.stemLabel = [[UILabel alloc]init];
    self.stemLabel.font = [UIFont boldSystemFontOfSize:14];
    self.stemLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.stemLabel.numberOfLines = 0;
    [self.contentView addSubview:self.stemLabel];
    [self.stemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.indexLabel.mas_right);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(25);
    }];
    
    self.attendLabel = [[UILabel alloc]init];
    self.attendLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    self.attendLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.attendLabel];
    [self.attendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.mas_equalTo(self.stemLabel.mas_bottom).mas_offset(25);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    bgView.layer.cornerRadius = 9;
    bgView.clipsToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.attendLabel.mas_left);
        make.top.mas_equalTo(self.attendLabel.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-25);
    }];
    
    UILabel *myReplyLabel = [[UILabel alloc]init];
    myReplyLabel.text = @"我的回复：";
    myReplyLabel.font = [UIFont systemFontOfSize:14];
    myReplyLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [bgView addSubview:myReplyLabel];
    [myReplyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [bgView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(myReplyLabel.mas_left);
        make.top.mas_equalTo(myReplyLabel.mas_bottom).mas_offset(7);
    }];
    self.replyTextView = [[UITextView alloc]init];
    self.replyTextView.font = [UIFont systemFontOfSize:14];
    self.replyTextView.textColor = [UIColor colorWithHexString:@"333333"];
    self.replyTextView.backgroundColor = [UIColor clearColor];
    self.replyTextView.textContainerInset = UIEdgeInsetsZero;
    self.replyTextView.userInteractionEnabled = NO;
    [bgView addSubview:self.replyTextView];
    [self.replyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(13);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-15);
    }];
    
    [self.indexLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.indexLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.stemLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.stemLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLineView.hidden = bottomLineHidden;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    NSString *indexStr = [NSString stringWithFormat:@"%@、",@(index)];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:indexStr attributes:dic];
    self.indexLabel.attributedText = attributeStr;
}

- (void)setItem:(QuestionRequestItem_question *)item {
    _item = item;
    self.timeLabel.text = [self dateStringFromOriString:self.item.createTime];
    self.attendLabel.text = [NSString stringWithFormat:@"参与人数：%@",self.item.answerUserNum];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    NSString *stem = self.item.title;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:stem attributes:dic];
    self.stemLabel.attributedText = attributeStr;
    
    NSString *comment = self.item.myAnswers.firstObject;
    attributeStr = [[NSAttributedString alloc] initWithString:comment attributes:dic];
    self.replyTextView.attributedText = attributeStr;
    CGSize size = [self.replyTextView sizeThatFits:CGSizeMake(SCREEN_WIDTH-35-15-12-12, CGFLOAT_MAX)];
    CGFloat height = MAX(size.height, 180.f);
    [self.replyTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (NSString *)dateStringFromOriString:(NSString *)oriStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:oriStr];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:self.currentTime.doubleValue/1000];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:date];
    if (interval >= 24*60*60) {
        return oriStr;
    }else if (interval < 60*60) {
        NSInteger min = interval/60;
        return [NSString stringWithFormat:@"%@分钟前",@(min)];
    }else {
        NSInteger hour = interval/60/60;
        return [NSString stringWithFormat:@"%@小时前",@(hour)];
    }
}

@end
