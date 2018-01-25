//
//  ClassMomentUserMomentMsgRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2018/1/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassMomentUserMomentMsgRequest.h"
@implementation ClassMomentUserMomentMsgItem_Data_Msg_MomentSimple
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"momentId"}];
}

@end


@implementation ClassMomentUserMomentMsgItem_Data_Msg
@end


@implementation ClassMomentUserMomentMsgItem_Data
@end

@implementation ClassMomentUserMomentMsgItem : HttpBaseRequestItem

@end
@implementation ClassMomentUserMomentMsgRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.moment.getUserMomentMsg";
    }
    return self;
}
@end
