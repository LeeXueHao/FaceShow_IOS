//
//  IMImageMessage.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMMember;

@interface IMImageMessage : NSObject
@property (nonatomic, assign) int64_t topicID;
@property (nonatomic, assign) int64_t groupID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) uint64_t width;
@property (nonatomic, assign) uint64_t height;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) NSString *resourceID;
@property (nonatomic, strong) IMMember *otherMember;
@end
