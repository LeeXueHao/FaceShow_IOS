//
//  ClassMomentUserListRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentUserListRequest.h"
@implementation ClassMomentUserListItem
@end
@implementation ClassMomentUserListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.moment.getMoments";
    }
    return self;
}
@end
