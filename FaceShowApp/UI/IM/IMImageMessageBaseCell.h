//
//  IMImageMessageBaseCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMMessageBaseCell.h"
#import "IMImageSendingProgressView.h"

static const CGFloat kMaxImageSizeHeight = 140;
static const CGFloat kMinImageSizeHeight = 55;
static const CGFloat kMinImageSizewidth = 70;

@interface IMImageMessageBaseCell : IMMessageBaseCell

@property (nonatomic, strong) UIImageView *messageImageview;

@property (nonatomic, strong) IMImageSendingProgressView *progressView;

- (CGSize)aspectFitOriginalSize:(CGSize)originalSize withReferenceSize:(CGSize)referenceSize;
@end
