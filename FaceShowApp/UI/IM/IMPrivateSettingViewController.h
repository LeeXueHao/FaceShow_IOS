//
//  IMPrivateSettingViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/5/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "IMTopic.h"
@class IMTopicInfoItem;

@interface IMPrivateSettingViewController : BaseViewController
@property (nonatomic, strong) IMTopic *topic;
@property (nonatomic, strong) IMTopicInfoItem *info;//没有topic的时候,显示所需要的信息(包括member和group信息)
@end
