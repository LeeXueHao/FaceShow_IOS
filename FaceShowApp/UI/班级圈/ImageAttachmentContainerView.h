//
//  ImageAttachmentContainerView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAttachmentContainerView : UIView
+ (CGFloat)heightForCount:(NSInteger)count;

@property (nonatomic, strong) void(^imagesChangeBlock)(NSArray *images);
@end
