//
//  ChatViewController.h
//  FaceShowApp
//
//  Created by ZLL on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
@class IMTopic;
@class IMMember;
@class IMTopicMessage;

@interface ChatViewController : BaseViewController
@property (nonatomic, strong) IMTopic *topic;
@property (nonatomic, strong) IMMember *member;
@property (nonatomic, strong) NSString *groupId;//没有topic的时候 member所在的group的id
@property (nonatomic, strong) void(^exitBlock)(void);
@end
