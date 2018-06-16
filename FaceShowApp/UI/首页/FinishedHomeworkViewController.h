//
//  FinishedHomeworkViewController.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"
@class GetHomeworkRequestItem_userHomework;
@class GetHomeworkRequestItem_homework;

@interface FinishedHomeworkViewController : ScrollBaseViewController
@property(nonatomic, strong) GetHomeworkRequestItem_userHomework *userHomework;
@property(nonatomic, strong) GetHomeworkRequestItem_homework *homework;
@end
