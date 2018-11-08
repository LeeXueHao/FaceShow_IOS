//
//  GroupDetailByStudentRequest.m
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GroupDetailByStudentRequest.h"

@implementation GroupDetailByStudentRequest_Item_students
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"studentsId"}];
}
@end

@implementation GroupDetailByStudentRequest_Item_group
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"groupId"}];
}
@end

@implementation GroupDetailByStudentRequest_Item_data
@end

@implementation GroupDetailByStudentRequest_Item
@end

@implementation GroupDetailByStudentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.group.detailByStudent";
    }
    return self;
}
@end
