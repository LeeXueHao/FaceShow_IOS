//
//  ChatViewController.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

UIKIT_EXTERN NSNotificationName const kIMUnreadMessageCountClearNotification;

@class IMTopic;
@class IMTopicInfoItem;

@interface ChatViewController : BaseViewController
@property (nonatomic, strong) IMTopic *topic;
@property (nonatomic, strong) IMTopicInfoItem *info;//没有topic的时候 显示所需要的信息(包括member和group信息)
@end
