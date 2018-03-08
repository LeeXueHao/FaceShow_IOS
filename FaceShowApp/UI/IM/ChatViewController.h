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

@interface ChatViewController : BaseViewController
@property (nonatomic, strong) IMTopic *topic;
@property (nonatomic, strong) IMMember *member;
@property (nonatomic, strong) void(^exitBlock)(void);
@end
