//
//  ClassMomentCell.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentCell.h"
@interface ClassMomentCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@end
@implementation ClassMomentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"dfe3e6"];
    [self.contentView addSubview:self.topView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe3e6"];
    [self.contentView addSubview:self.bottomView];
    
    CGRect bottomRect = CGRectMake(0, 0, SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f, 10.0f);
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRoundedRect:bottomRect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0f, 5.0f)];
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.frame = bottomRect ;
    self.bottomLayer.path = bottomPath.CGPath;
    self.bottomView.layer.mask = self.bottomLayer;
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.numberOfLines = 0;
    [self.topView addSubview:self.contentLabel];
}
- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f + 40.0f + 10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f + 40.0f + 10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(10.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10.0f);
        make.right.equalTo(self.topView.mas_right).offset(-10.0f);
        make.top.equalTo(self.topView.mas_top);
        make.bottom.equalTo(self.topView.mas_bottom);
    }];
    
}

- (void)reloadName:(NSString *)nameString withComment:(NSString *)commentString withLast:(BOOL)isLast {
    if (isLast) {
        commentString = @"的发酒疯流口水的积分蓝思科技的;付了款加上了;看风景;了会计师了副科级是凉快点积分蓝思科技傅雷家书敦伦尽分";
    }
    NSString *tempString = [NSString stringWithFormat:@"%@: %@",nameString,commentString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempString];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, tempString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:NSMakeRange(0, nameString.length)];
    self.contentLabel.attributedText = attributedString;
    self.bottomView.layer.mask =  isLast ? self.bottomLayer : nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
