//
//  ClassMomentTableHeaderView.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassMomentTableHeaderView : UIView
@property (nonatomic, assign) NSInteger messageInteger;
@property (nonatomic, copy) void(^classMomentUserButtonBlock)(NSInteger tag);
- (void)reload;
@end
