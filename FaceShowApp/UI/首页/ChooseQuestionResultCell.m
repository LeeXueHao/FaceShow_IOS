//
//  ChooseQuestionResultCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ChooseQuestionResultCell.h"

@interface ChooseQuestionResultCell()
@property (nonatomic, strong) NSMutableArray<OptionItemResultView *> *itemViewArray;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *stemLabel;
@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, strong) NSString *stem;
@property (nonatomic, strong) NSArray<QuestionRequestItem_voteItems *> *optionArray;
@end

@implementation ChooseQuestionResultCell

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
    self.stem = [NSString stringWithFormat:@"%@(%@)",item.title,item.questionTypeName];
    self.optionArray = item.voteInfo.voteItems;
}

- (void)setStem:(NSString *)stem {
    _stem = stem;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:stem attributes:dic];
    self.stemLabel.attributedText = attributeStr;
}

- (void)setOptionArray:(NSArray *)optionArray {
    _optionArray = optionArray;
    for (UIView *item in self.itemViewArray) {
        [item removeFromSuperview];
    }
    self.itemViewArray = [NSMutableArray array];
    __block UIView *preView = nil;
    [optionArray enumerateObjectsUsingBlock:^(QuestionRequestItem_voteItems *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OptionItemResultView *itemView = [self itemViewWithOption:obj index:idx];
        [self.itemViewArray addObject:itemView];
        [self.contentView addSubview:itemView];
        if (idx == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(self.stemLabel.mas_bottom).mas_offset(25);
            }];
        }else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(preView.mas_bottom).mas_offset(10);
            }];
        }
        if (idx == optionArray.count-1) {
            [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-30);
            }];
        }
        preView = itemView;
    }];
}

- (OptionItemResultView *)itemViewWithOption:(QuestionRequestItem_voteItems *)option index:(NSInteger)index{
    OptionItemResultView *itemView = [[OptionItemResultView alloc]init];
    itemView.index = index;
    itemView.item = option;
    return itemView;
}

@end
