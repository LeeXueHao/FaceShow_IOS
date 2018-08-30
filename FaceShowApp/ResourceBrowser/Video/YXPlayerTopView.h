//
//  YXPlayerTopView.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/26/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXPlayerTopView : UIView
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *favorButton;
@property (nonatomic, strong) UIButton *likeButton;


@property (nonatomic, strong) UIButton *previewFavorButton; // 用于预览时保存这个资源
@end
