//
//  TaskFilterView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskFilterItemView.h"

@interface TaskFilterView : UIView
@property(nonatomic, copy) void(^taskFilterItemChooseBlock)(TaskFilterItem *item);
@end
