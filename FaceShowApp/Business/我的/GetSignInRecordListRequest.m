//
//  GetSignInRecordListRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetSignInRecordListRequest.h"

@implementation GetSignInRecordListRequestItem_SignIn
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"signInId" : @"id"}];
}
@end

@implementation GetSignInRecordListRequestItem_Clazs
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"clazsId" : @"id", @"descriptionStr" : @"description"}];
}
@end

@implementation GetSignInRecordListRequestItem_Element
@end

@implementation GetSignInRecordListRequestItem_Data
@end

@implementation GetSignInRecordListRequestItem
@end

@implementation GetSignInRecordListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.userSignInRecords";
    }
    return self;
}
@end
