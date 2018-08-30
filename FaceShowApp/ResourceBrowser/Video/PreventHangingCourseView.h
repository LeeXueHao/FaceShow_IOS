//
//  PreventHangingCourseView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PreventHangingCourseBlock)(void);
@interface PreventHangingCourseView : UIView
- (void)setPreventHangingCourseBlock:(PreventHangingCourseBlock)block;
@end
