//
//  YXSlideProgressView.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXSlideProgressView : UIControl
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) CGFloat bufferProgress;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL bSliding;

- (void)updateUI;
@end
