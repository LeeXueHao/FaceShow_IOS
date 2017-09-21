//
//  TaskCell.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetTaskRequest.h"

@interface TaskCell : UITableViewCell
@property (nonatomic, strong) GetTaskRequestItem_Task *task;
@end
