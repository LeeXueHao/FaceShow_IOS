//
//  IMMember.h
//  TestIM
//
//  Created by niuzhaowang on 2018/1/2.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMMember : NSObject
@property (nonatomic, assign) int64_t memberID;
@property (nonatomic, assign) int64_t userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@end
