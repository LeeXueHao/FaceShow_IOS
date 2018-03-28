//
//  IMHistoryFetchRecord.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMTopic.h"

@interface IMHistoryFetchRecord : NSObject
@property (nonatomic, strong) IMTopic *topic;
@property (nonatomic, strong) IMTopicMessage *beforeMsg;
@property (nonatomic, assign) NSInteger count;
@end
