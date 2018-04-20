//
//  IMImageMessageSender.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMImageMessage.h"

@interface IMImageMessageSender : NSObject
+ (IMImageMessageSender *)sharedInstance;

- (void)addImageMessage:(IMImageMessage *)msg;

- (UIImage *)cacheImageWithMessageUniqueID:(NSString *)uniqueID;

- (void)resendUncompleteMessage:(IMImageMessage *)msg;
@end
