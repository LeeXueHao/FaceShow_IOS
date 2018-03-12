//
//  IMChatViewModel.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMTopicMessage.h"
#import "IMTopic.h"

@interface IMChatViewModel : NSObject
@property(nonatomic, strong) IMTopicMessage *message;
@property(nonatomic, assign) TopicType topicType;
@property (nonatomic, assign) BOOL isTimeVisible;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat percent;
@end
