//
//  PreventHangingCourseView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PreventHangingCourseView.h"
@interface PreventHangingCourseView ()
@property (nonatomic, copy) PreventHangingCourseBlock touchBlock;
@end
@implementation PreventHangingCourseView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"睡了？"];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_offset(CGSizeMake(106.0f, 106));
        make.centerY.equalTo(self.mas_centerY).offset(-9.0f);
    }];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.text = @"点击屏幕继续看课";
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(4.0f);
    }];
    
    
}

- (void)setPreventHangingCourseBlock:(PreventHangingCourseBlock)block {
    self.touchBlock = block;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.hidden = YES;
   BLOCK_EXEC(self.touchBlock);
}
@end
