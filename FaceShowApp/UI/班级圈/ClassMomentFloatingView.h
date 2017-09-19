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

@interface ClassMomentFloatingView : UIView
@property (nonatomic, assign) CGRect originRect;
@property (nonatomic, copy) void(^classMomentFloatingBlock)(ClassMomentClickStatus status);
@end
