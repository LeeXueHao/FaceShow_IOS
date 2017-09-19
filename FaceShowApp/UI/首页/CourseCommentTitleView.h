//
//  CourseCommentTitleView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCommentTitleView : UIView
@property (nonatomic, strong) NSString *title;

+ (CGFloat)heightForTitle:(NSString *)title;
@end
