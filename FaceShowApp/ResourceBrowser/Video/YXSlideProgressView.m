//
//  YXSlideProgressView.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXSlideProgressView.h"
#import "YXGradientView.h"
@interface YXSlideProgressView()
@property (nonatomic, strong) UIImageView *thumbNormalView;


@property (nonatomic, strong) UIView *wholeProgressView;
@property (nonatomic, strong) YXGradientView *playProgressView;
@property (nonatomic, strong) UIView *bufferProgressView;
@end

@implementation YXSlideProgressView {
    UIImage *_iconImage;
}
- (id)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.bSliding = NO;
    
    self.wholeProgressView = [[UIView alloc] init];
    self.wholeProgressView.backgroundColor = [UIColor colorWithHexString:@"#919191"];
    [self addSubview:self.wholeProgressView];
    self.wholeProgressView.userInteractionEnabled = NO;
    
    self.bufferProgressView = [[UIView alloc] init];
    self.bufferProgressView.backgroundColor = [UIColor colorWithHexString:@"a2d2df"];
    [self addSubview:self.bufferProgressView];
    self.bufferProgressView.userInteractionEnabled = NO;
    
    self.playProgressView = [[YXGradientView alloc]initWithStartColor:[UIColor colorWithHexString:@"4cdafd"] endColor:[UIColor colorWithHexString:@"4692a7"] orientation:YXGradientLeftToRight];;
    [self addSubview:self.playProgressView];
    self.playProgressView.userInteractionEnabled = NO;
    
    self.thumbNormalView = [[UIImageView alloc] init];
    self.thumbNormalView.frame = CGRectMake(0, 0, 16.0f, 16.0f);
    self.thumbNormalView.backgroundColor = [UIColor whiteColor];
    self.thumbNormalView.layer.cornerRadius = 8.0f;
    self.thumbNormalView.clipsToBounds = YES;
    self.thumbNormalView.layer.masksToBounds = YES;
    [self addSubview:self.thumbNormalView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.timeLabel];
    
    [self.wholeProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbNormalView.bounds.size.width * 0.5).priorityHigh();
        make.centerY.mas_equalTo(@0);
        make.height.mas_equalTo(@3.0f);
        make.right.equalTo(self.timeLabel.mas_left).offset(-6.0f).priorityHigh();
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.right.mas_equalTo(@-5.0).priorityHigh();
        make.width.mas_offset(70.0f);
    }];
}

- (void)layoutSubviews {
    [self updateUI];
    [super layoutSubviews];
}

- (void)updateUI {
    [self.bufferProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wholeProgressView.mas_left);
        make.top.mas_equalTo(self.wholeProgressView.mas_top);
        make.bottom.mas_equalTo(self.wholeProgressView.mas_bottom);
        make.width.mas_equalTo(self.wholeProgressView.mas_width).multipliedBy(self.bufferProgress).priorityHigh();
    }];
    
    [self.playProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wholeProgressView.mas_left);
        make.top.mas_equalTo(self.wholeProgressView.mas_top);
        make.bottom.mas_equalTo(self.wholeProgressView.mas_bottom);
        make.width.mas_equalTo(self.wholeProgressView.mas_width).multipliedBy(self.playProgress).priorityHigh();
    }];
    
    [self.thumbNormalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.0f, 16.0f));
        make.centerX.mas_equalTo(self.wholeProgressView.mas_left).mas_offset(self.wholeProgressView.bounds.size.width * self.playProgress);
        make.centerY.mas_equalTo(self.wholeProgressView.mas_centerY);
    }];
    
    self.timeLabel.attributedText = [self palyTime:[self timeString:self.duration * self.playProgress] withContent:[self timeString:self.duration]];
}

- (NSMutableAttributedString *)palyTime:(NSString *)playTime withContent:(NSString *)durationTime{
    NSString *temString = [NSString stringWithFormat:@"%@/%@",playTime,durationTime];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:temString];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, [temString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, playTime.length + 1)];
    return attributedString;
}

- (NSString *)timeString:(NSTimeInterval)time {
    int minute = (int)(time / 60);
    int second = ((int)time) % 60;
    NSString *ret = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    return ret;
}


#pragma mark - touch event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint([self slidePointImageRect], touchPoint)) {
        self.bSliding = YES;
        self.thumbNormalView.image = [UIImage imageWithColor:[UIColor whiteColor]];
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat startX = self.wholeProgressView.bounds.origin.x;
    CGFloat endX = self.wholeProgressView.bounds.origin.x + self.wholeProgressView.bounds.size.width;
    touchPoint.x = MAX(startX, touchPoint.x);
    touchPoint.x = MIN(endX, touchPoint.x);
    
    self.playProgress = (touchPoint.x - startX) / (endX - startX);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsLayout];
    self.bSliding = YES;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.bSliding = NO;
    self.thumbNormalView.image = [UIImage imageWithColor:[UIColor whiteColor]];
}

- (CGRect)slidePointImageRect {
    CGRect rect = self.thumbNormalView.frame;
    rect.size.width  = rect.size.width + 8;//拖动按钮的区域增加8个像素
    rect.size.height = rect.size.height + 8;
    DDLogDebug(@"%@", NSStringFromCGRect(rect));
    return rect;
}

@end
