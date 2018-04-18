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
@class IMMember;

@interface ChatViewController : BaseViewController
@property (nonatomic, strong) IMTopic *topic;
@property (nonatomic, strong) IMMember *anotherMember;//没有topic的时候 topic中除了自己之外的另一个member
@property (nonatomic, strong) NSString *groupId;//没有topic的时候 anotherMember所在的group的id
@end
