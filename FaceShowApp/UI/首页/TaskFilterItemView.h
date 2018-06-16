//
//  TaskFilterItemView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSDataMappingTable.h"
@class GetAllTasksRequestItem_interactType;

@interface TaskFilterItemView : UIView
@property(nonatomic, strong) GetAllTasksRequestItem_interactType *item;
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, copy) void(^taskFilterItemChooseBlock)(GetAllTasksRequestItem_interactType *item);
@end
