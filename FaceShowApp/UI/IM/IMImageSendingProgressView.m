//
//  IMImageSendingProgressView.m
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMImageSendingProgressView.h"
#import "UIImage+GIF.h"

@interface IMImageSendingProgressView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *progressLabel;
@end

@implementation IMImageSendingProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage nyx_animatedGIFNamed:@"加载动效"];
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.font = [UIFont systemFontOfSize:16.f];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupLayout {
    [self addSubview:self.imageView];
    [self addSubview:self.progressLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-8);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(2);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)setProgress:(NSString *)progress {
    _progress = progress;
    CGFloat persent = progress.floatValue;
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%@",persent*100,@"%"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ];
}
@end
