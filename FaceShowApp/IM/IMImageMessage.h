//
//  IMImageMessage.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMImageMessage : NSObject
@property (nonatomic, assign) uint64_t topicID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) IMMember *otherMember;
@end
