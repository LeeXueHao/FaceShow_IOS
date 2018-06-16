//
//  TaskFilterView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetAllTasksRequestItem_interactType;

@interface TaskFilterView : UIView
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, copy) void(^taskFilterItemChooseBlock)(GetAllTasksRequestItem_interactType *item);
- (instancetype)initWithDataArray:(NSArray *)dataArray;
- (void)reloadTaskFilterWithIndex:(NSInteger)index;
@end
