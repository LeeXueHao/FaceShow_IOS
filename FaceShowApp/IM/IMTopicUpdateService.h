//
//  IMTopicUpdateService.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMTopic.h"

@interface IMTopicUpdateService : NSObject
- (void)addTopic:(IMTopic *)topic;
@end
