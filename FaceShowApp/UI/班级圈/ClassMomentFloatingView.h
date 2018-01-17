//
//  ClassMomentFloatingView.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ClassMomentClickStatus) {
    ClassMomentClickStatus_Like = 1,//点赞
    ClassMomentClickStatus_Comment = 2,//评论
    ClassMomentClickStatus_Delete = 3,//删除
    ClassMomentClickStatus_Cancel = 4//取消点赞
};
typedef NS_OPTIONS(NSInteger,ClassMomentFloatingStyle){
    ClassMomentFloatingStyle_Like = 1 << 0,
    ClassMomentFloatingStyle_Comment = 1 << 1,
    ClassMomentFloatingStyle_Delete = 1 << 2,
    ClassMomentFloatingStyle_Cancel = 1 << 3
    
};

@interface ClassMomentFloatingView : UIView
@property (nonatomic, copy) void(^classMomentFloatingBlock)(ClassMomentClickStatus status);
- (void)reloadFloatingView:(CGRect)originRect withStyle:(ClassMomentFloatingStyle)style;
- (void)hiddenViewAnimate:(BOOL)animate;

@end
