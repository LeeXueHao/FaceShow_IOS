//
//  TaskCommentViewController.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"

@interface TaskCommentViewController : PagedListViewControllerBase
- (instancetype)initWithStepId:(NSString *)stepId;
@property (nonatomic, strong) void(^completeBlock) (void);
@end
