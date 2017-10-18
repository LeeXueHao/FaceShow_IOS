//
//  ClassMomentListRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentListRequest.h"


@implementation ClassMomentListRequestItem_Data_Moment_Comment
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"commentID",
                                                       @"clazsId":@"clazsID",
                                                       @"momentId":@"momentID",
                                                       @"parentId":@"parentID"}];
}

@end
@implementation ClassMomentListRequestItem_Data_Moment_Album_Attachment
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"resId":@"resID"}];
}
@end
@implementation ClassMomentListRequestItem_Data_Moment_Album
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"albumID",
                                                       @"momentId":@"momentID"}];
}
@end

@implementation ClassMomentListRequestItem_Data_Moment_Like
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"likeID",
                                                       @"clazsId":@"clazsID",
                                                       @"momentId":@"momentID"}];
}
@end

@implementation ClassMomentListRequestItem_Data_Moment
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"momentID",
                                                       @"clazsId":@"clazsID",
                                                       @"album":@"albums"}];
}
- (NSString<Optional> *)isOpen {
    if (_isOpen == nil) {
        return @"0";
    }
    return _isOpen;
}
@end
@implementation ClassMomentListRequestItem_Data
@end
@implementation ClassMomentListRequestItem
@end
@implementation ClassMomentListRequestItem_UserInfo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"userId":@"userID"}];
}

@end

@implementation ClassMomentListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.moment.getMoments";
    }
    return self;
}
@end
