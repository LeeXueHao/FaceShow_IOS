//
//  HomeworkRequirementViewController.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"
@class GetHomeworkRequestItem_homework;
@class GetHomeworkRequestItem_userHomework;

@interface HomeworkRequirementViewController : ScrollBaseViewController
@property (nonatomic, assign) BOOL isFinished;
@property(nonatomic, strong) GetHomeworkRequestItem_homework *homework;
@property(nonatomic, strong) GetHomeworkRequestItem_userHomework *userHomework;
@end
