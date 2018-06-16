//
//  TaskTopView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetUserTaskProgressRequestItem;

@interface TaskTopView : UIView
@property (nonatomic, copy) void(^rankingChoosedBlock)(void);
@property(nonatomic, strong) GetUserTaskProgressRequestItem *item;
@end
