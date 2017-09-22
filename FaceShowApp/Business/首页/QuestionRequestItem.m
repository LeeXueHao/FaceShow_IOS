//
//  QuestionRequestItem.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionRequestItem.h"
#import "FSDataMappingTable.h"

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

- (NSMutableArray *)myAnswers {
    if (_myAnswers) {
        return _myAnswers;
    }
    _myAnswers = [NSMutableArray array];
    QuestionType type = [FSDataMappingTable QuestionTypeWithKey:self.questionType];
    if (type==QuestionType_SingleChoose || type==QuestionType_MultiChoose) {
        for (int i=0; i<self.voteInfo.voteItems.count; i++) {
            [_myAnswers addObject:@(NO)];
        }
        NSMutableArray *itemIdArray = [NSMutableArray array];
        for (QuestionRequestItem_voteItems *item in self.voteInfo.voteItems) {
            [itemIdArray addObject:item.itemId];
        }
        for (NSString *answer in self.userAnswer.questionAnswers) {
            NSInteger index = [itemIdArray indexOfObject:answer];
            [_myAnswers replaceObjectAtIndex:index withObject:@(YES)];
        }
    }else if (type == QuestionType_Fill) {
        [_myAnswers addObjectsFromArray:self.userAnswer.questionAnswers];
        if (isEmpty(_myAnswers)) {
            [_myAnswers addObject:@""];
        }
    }
    return _myAnswers;
}

- (NSDictionary *)answerDict {
    NSString *answerStr = @"";
    QuestionType type = [FSDataMappingTable QuestionTypeWithKey:self.questionType];
    if (type==QuestionType_SingleChoose || type==QuestionType_MultiChoose) {
        NSMutableArray *array = [NSMutableArray array];
        [self.myAnswers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.boolValue) {
                QuestionRequestItem_voteItems *item = self.voteInfo.voteItems[idx];
                [array addObject:item.itemId];
            }
        }];
        answerStr = [array componentsJoinedByString:@","];
    }else if (type == QuestionType_Fill) {
        answerStr = self.myAnswers.firstObject;
    }
    return @{@"questionId":self.questionId,@"answers":answerStr};
}

- (BOOL)hasAnswer {
    QuestionType type = [FSDataMappingTable QuestionTypeWithKey:self.questionType];
    if (type==QuestionType_SingleChoose || type==QuestionType_MultiChoose) {
        for (NSNumber *num in self.myAnswers) {
            if (num.boolValue) {
                return YES;
            }
        }
        return NO;
    }else if (type == QuestionType_Fill) {
        NSString *answer = self.myAnswers.firstObject;
        if (isEmpty(answer)) {
            return NO;
        }
        return YES;
    }
    return NO;
}

@end

@implementation QuestionRequestItem_questionGroup
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"groupId",@"description":@"desc"}];
}

- (NSString *)answerString {
    NSMutableArray *array = [NSMutableArray array];
    for (QuestionRequestItem_question *q in self.questions) {
        [array addObject:[q answerDict]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}
@end

@implementation QuestionRequestItem_data

@end

@implementation QuestionRequestItem

@end
