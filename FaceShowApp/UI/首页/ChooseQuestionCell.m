//
//  ChooseQuestionCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ChooseQuestionCell.h"
#import "OptionItemView.h"

@interface ChooseQuestionCell()
@property (nonatomic, strong) NSMutableArray<OptionItemView *> *itemViewArray;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation ChooseQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLineView.hidden = bottomLineHidden;
}

- (void)setOptionArray:(NSArray *)optionArray {
    _optionArray = optionArray;
    for (UIView *item in self.itemViewArray) {
        [item removeFromSuperview];
    }
    self.itemViewArray = [NSMutableArray array];
    __block UIView *preView = nil;
    [optionArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OptionItemView *itemView = [self itemViewWithOption:obj];
        [self.itemViewArray addObject:itemView];
        [self.contentView addSubview:itemView];
        if (idx == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(20);
            }];
        }else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(preView.mas_bottom).mas_offset(10);
            }];
        }
        if (idx == optionArray.count-1) {
            [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-20);
            }];
        }
        preView = itemView;
    }];
}

- (OptionItemView *)itemViewWithOption:(NSString *)option {
    OptionItemView *itemView = [[OptionItemView alloc]init];
    itemView.option = option;
    WEAK_SELF
    [itemView setClickBlock:^(OptionItemView *view){
        STRONG_SELF
        if (view.isSelected) {
            [self refreshWithCurrentSelection:view];
        }
    }];
    return itemView;
}

- (void)refreshWithCurrentSelection:(OptionItemView *)itemView {
    for (OptionItemView *item in self.itemViewArray) {
        item.isSelected = NO;
    }
    itemView.isSelected = YES;
}

@end
