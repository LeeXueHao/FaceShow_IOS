//
//  IMTopicMessage.m
//  TestIM
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "IMTopicMessage.h"
#import "IMManager.h"
#import "IMImageMessageSender.h"

@implementation IMTopicMessage
- (BOOL)isFromCurrentUser {
    return self.sender.memberID == [[IMManager sharedInstance] currentMember].memberID;
}

- (NSString *)viewUrl {
    if (self.sendState == MessageSendState_Success) {
        return _viewUrl;
    }
    return [[[IMImageMessageSender sharedInstance] imageCacheFolderPath]stringByAppendingPathComponent:_viewUrl];
}
@end
