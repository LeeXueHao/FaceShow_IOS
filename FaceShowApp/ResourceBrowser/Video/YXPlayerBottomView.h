//
//  YXPlayerBottomView.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSlideProgressView.h"

@interface YXPlayerBottomView : UIView
@property (nonatomic, assign) BOOL bShowDefinition;

@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) YXSlideProgressView *slideProgressView;
@property (nonatomic, strong) UIButton *definitionButton;

- (void)setPlaying;
- (void)setPaused;
@end
