//
//  ImageAttachmentView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAttachmentView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) void(^tapBlock)(void);
@property (nonatomic, strong) void(^deleteBlock)(void);
@end
