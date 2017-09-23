//
//  ClassMomentFloatingView.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ClassMomentClickStatus) {
    ClassMomentClickStatus_Like = 1,
    ClassMomentClickStatus_Comment = 2
};
typedef NS_ENUM(NSInteger,ClassMomentFloatingStyle){
    ClassMomentFloatingStyle_Comment = 1,//只有评论按键
    ClassMomentFloatingStyle_Double = 2//点赞评论
    
};

@interface ClassMomentFloatingView : UIView

@property (nonatomic, copy) void(^classMomentFloatingBlock)(ClassMomentClickStatus status);
- (void)reloadFloatingView:(CGRect)originRect withStyle:(ClassMomentFloatingStyle)style;
- (void)hiddenView;

@end
