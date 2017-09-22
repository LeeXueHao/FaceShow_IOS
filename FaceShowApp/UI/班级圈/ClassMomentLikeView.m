//
//  ClassMomentLikeView.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentLikeView.h"
@interface ClassMomentLikeView ()
@property (nonatomic, strong) UIImageView *sharpImageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) UIImageView *heartImageView;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation ClassMomentLikeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
        
    }
    return self;
}
- (void)reloadLikes:(NSArray *)likes withType:(ClassMomentLikeType)type{
    switch (type) {
        case ClassMomentLikeType_Not:{
            self.lineView.hidden = YES;
            self.bottomView.layer.mask = nil;
            [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.height.mas_offset(0.0001f);

            }];
            
            [self.middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.height.mas_offset(0.0001f);

            }];
            
            [self.likeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.edges.equalTo(self);
                make.height.mas_offset(0.0001f);

            }];
            
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.height.mas_offset(0.0001f);
            }];
        }
            break;
        case ClassMomentLikeType_Like:
        {
            self.lineView.hidden = YES;
            self.bottomView.layer.mask = self.bottomLayer;
            [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.mas_offset(10.0f).priorityLow();
                make.top.equalTo(self.sharpImageView.mas_centerY);
            }];
            
            [self.middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.topView.mas_bottom);
                make.right.equalTo(self.mas_right);
            }];
            
            [self.likeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.heartImageView.mas_right).offset(6.0f);
                make.right.equalTo(self.middleView.mas_right).offset(-15.0f);
                make.top.equalTo(self.heartImageView.mas_top).offset(-5.0f);
                make.bottom.equalTo(self.middleView.mas_bottom);
            }];
            
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.mas_offset(10.0f).priorityLow();
                make.bottom.equalTo(self.mas_bottom);
                make.top.equalTo(self.middleView.mas_bottom);
            }];
        }
            break;
        case ClassMomentLikeType_Comment:
        {
            self.lineView.hidden = YES;
            [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.mas_offset(10.0f).priorityLow();
                make.top.equalTo(self.sharpImageView.mas_centerY);
                make.bottom.equalTo(self.mas_bottom);
            }];
            [self.middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.topView.mas_bottom);
                make.right.equalTo(self.mas_right);
            }];
            
            [self.likeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.heartImageView.mas_right).offset(6.0f);
                make.right.equalTo(self.middleView.mas_right).offset(-15.0f);
                make.top.equalTo(self.heartImageView.mas_top).offset(-5.0f);
                make.height.mas_offset(0.0001f);
            }];
            
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.mas_offset(0.0001f);
                make.top.equalTo(self.middleView.mas_bottom);
            }];
        }
            break;
        case ClassMomentLikeType_Double:
        {
            self.lineView.hidden = NO;
            self.bottomView.layer.mask = nil;
            [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.mas_offset(10.0f).priorityLow();
                make.top.equalTo(self.sharpImageView.mas_centerY);
            }];
            
            [self.middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.topView.mas_bottom);
                make.right.equalTo(self.mas_right);
            }];
            
            [self.likeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.heartImageView.mas_right).offset(6.0f);
                make.right.equalTo(self.middleView.mas_right).offset(-15.0f);
                make.top.equalTo(self.heartImageView.mas_top).offset(-5.0f);
                make.bottom.equalTo(self.middleView.mas_bottom);
            }];
            
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.mas_offset(20.0f).priorityLow();
                make.bottom.equalTo(self.mas_bottom);
                make.top.equalTo(self.middleView.mas_bottom);
            }];            
        }
            break;
    }
    if (likes.count > 0) {
        NSMutableArray *mutableArrray = [[NSMutableArray alloc] init];
        [likes enumerateObjectsUsingBlock:^(ClassMomentListRequestItem_Data_Moment_Like *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArrray addObject:obj.publisher.realName?:@""];
        }];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 1.2f;
        NSAttributedString *attributedString  = [[NSAttributedString alloc] initWithString:[mutableArrray componentsJoinedByString:@","] attributes:@{NSParagraphStyleAttributeName :paragraphStyle}];
        self.likeLabel.attributedText = attributedString;
    }else {
        self.likeLabel.attributedText = nil;
    }
}

#pragma mark - setupUI
- (void)setupUI {
    self.sharpImageView = [[UIImageView alloc] init];
    self.sharpImageView.backgroundColor = [UIColor colorWithHexString:@"dfe3e6"];
    self.sharpImageView.layer.cornerRadius = 35.0f;
    [self addSubview:self.sharpImageView];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"dfe3e6"];
    [self addSubview:self.topView];
    CGRect topRect = CGRectMake(0, 0, SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f, 10.0f);
    UIBezierPath *topPath = [UIBezierPath bezierPathWithRoundedRect:topRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5.0f, 5.0f)];
    CAShapeLayer *topLayer = [CAShapeLayer layer];
    topLayer.frame = topRect ;
    topLayer.path = topPath.CGPath;
    self.topView.layer.mask = topLayer;
    
    
    self.middleView = [[UIView alloc] init];
    self.middleView.backgroundColor = [UIColor colorWithHexString:@"dfe3e6"];
    [self addSubview:self.middleView];
    
    self.heartImageView = [[UIImageView alloc] init];
    self.heartImageView.image = [UIImage imageNamed:@"赞点后的小标签"];
    [self.middleView addSubview:self.heartImageView];
    
    self.likeLabel = [[UILabel alloc] init];
    self.likeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.likeLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.likeLabel.text = @"";
    self.likeLabel.numberOfLines = 0;
    [self.middleView addSubview:self.likeLabel];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe3e6"];
    [self addSubview:self.bottomView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d5d8db"];
    [self.bottomView addSubview:self.lineView];
    
    CGRect bottomRect = CGRectMake(0, 0, SCREEN_WIDTH - 15.0f - 40.0f - 10.0f - 15.0f, 10.0f);
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRoundedRect:bottomRect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0f, 5.0f)];
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.frame = bottomRect ;
    self.bottomLayer.path = bottomPath.CGPath;
    self.bottomView.layer.mask = self.bottomLayer;
}
- (void)setupLayout {
    [self.sharpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.top.equalTo(self.mas_top);
        make.size.mas_offset(CGSizeMake(28.0f, 28.0f)).priorityLow();
    }];
    
    [self.heartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView.mas_left).offset(8.0f);
        make.top.equalTo(self.topView.mas_bottom);
        make.size.mas_offset(CGSizeMake(12.0f, 12.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left);
        make.right.equalTo(self.bottomView.mas_right);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.height.mas_offset(1.0f);
    }];
}
@end
