//
//  QuestionRequestItem.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionRequestItem.h"

@implementation QuestionRequestItem_voteItems

@end

@implementation QuestionRequestItem_voteInfo

@end

@implementation QuestionRequestItem_userAnswer

@end

@implementation QuestionRequestItem_question
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"questionId",@"description":@"desc"}];
}
@end

@implementation QuestionRequestItem_questionGroup
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"groupId",@"description":@"desc"}];
}
@end

@implementation QuestionRequestItem_data

@end

@implementation QuestionRequestItem

@end
