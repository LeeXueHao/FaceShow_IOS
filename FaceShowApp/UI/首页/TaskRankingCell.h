//
//  TaskRankingCell.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetUserTasksProgressRankRequestItem_element;

@interface TaskRankingCell : UITableViewCell
@property (nonatomic, strong) GetUserTasksProgressRankRequestItem_element *element;
@property(nonatomic, assign) BOOL isShowLine;
@end
