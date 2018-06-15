//
//  TaskFilterItemView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSDataMappingTable.h"

@interface TaskFilterItem : UIView
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) InteractType type;
@property(nonatomic, assign) NSInteger finishedTask;
@property(nonatomic, assign) NSInteger totalTask;
@end

@interface TaskFilterItemView : UIView
@property(nonatomic, strong) TaskFilterItem *item;
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, copy) void(^taskFilterItemChooseBlock)(TaskFilterItem *item);
@end
