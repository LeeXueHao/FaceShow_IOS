//
//  IMTextMessage.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMember.h"

@interface IMTextMessage : NSObject
@property (nonatomic, assign) uint64_t topicID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) IMMember *otherMember;
@end
