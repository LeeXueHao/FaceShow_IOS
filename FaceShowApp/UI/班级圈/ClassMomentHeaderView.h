//
//  ClassMomentHeaderView.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassMomentListRequest.h"
@interface ClassMomentHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) void(^classMomentLikeCommentBlock)(UIButton *sender);
@property (nonatomic, copy) void(^classMomentOpenCloseBlock)(BOOL isOpen);
@property (nonatomic, strong) ClassMomentListRequestItem_Data_Moment *moment;
@end
