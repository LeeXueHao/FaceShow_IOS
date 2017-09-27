//
//  FillQuestionCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FillQuestionCell.h"
#import <SAMTextView.h>

@interface FillQuestionCell()<UITextViewDelegate>
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *stemLabel;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) SAMTextView *textView;

@property (nonatomic, strong) NSString *stem;
@property (nonatomic, strong) NSString *comment;
@end

@implementation FillQuestionCell

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
    
    self.textView = [[SAMTextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    NSString *placeholderStr = @"暂不支持表情,最多输入250个评价文字";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, placeholderStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, placeholderStr.length)];
    self.textView.attributedPlaceholder = attrStr;
    self.textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.textView.layer.cornerRadius = 9;
    self.textView.clipsToBounds = YES;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.textView.typingAttributes = dic;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.stemLabel.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(-25);
        make.height.mas_equalTo(180);
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
    self.stem = item.title;
    self.comment = item.myAnswers.firstObject;
}

- (void)setStem:(NSString *)stem {
    _stem = stem;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:stem attributes:dic];
    self.stemLabel.attributedText = attributeStr;
}

- (void)setComment:(NSString *)comment {
    if (!comment) {
        comment = @"";
    }
    _comment = comment;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:comment attributes:dic];
    self.textView.attributedText = attributeStr;
    CGSize size = [self.textView sizeThatFits:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX)];
    CGFloat height = MAX(size.height, 180.f);
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    BLOCK_EXEC(self.endEdittingBlock);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    BLOCK_EXEC(self.beginEdittingBlock);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *finalString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (finalString.length > 250) {
        return NO;
    }
    return YES;
}

@end
