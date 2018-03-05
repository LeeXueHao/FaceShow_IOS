//
//  IMImageMessageBaseCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMMessageBaseCell.h"
#import "IMImageSendingProgressView.h"

@interface IMImageMessageBaseCell : IMMessageBaseCell

@property (nonatomic, strong) UIImageView *messageImageview;

@property (nonatomic, strong) IMImageSendingProgressView *progressView;

@end
