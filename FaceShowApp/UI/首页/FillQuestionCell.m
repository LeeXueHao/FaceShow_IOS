//
//  FillQuestionCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FillQuestionCell.h"

@interface FillQuestionCell()
@property (nonatomic, strong) UIView *bottomLineView;
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

@end
