//
//  QuestionRequestItem.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HttpBaseRequest.h"

@protocol QuestionRequestItem_voteItems <NSObject>
@end
@interface QuestionRequestItem_voteItems : JSONModel
@property (nonatomic, strong) NSString<Optional> *itemId;
@property (nonatomic, strong) NSString<Optional> *itemName;
@property (nonatomic, strong) NSString<Optional> *selectedNum;
@property (nonatomic, strong) NSString<Optional> *percent;
@end

@interface QuestionRequestItem_voteInfo : JSONModel
@property (nonatomic, strong) NSArray<Optional,QuestionRequestItem_voteItems> *voteItems;
@property (nonatomic, strong) NSString<Optional> *maxSelectNum;
@end

@interface QuestionRequestItem_userAnswer : JSONModel
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *questionId;
@property (nonatomic, strong) NSArray<Optional> *questionAnswers;
@end

@protocol QuestionRequestItem_question <NSObject>
@end
@interface QuestionRequestItem_question : JSONModel
@property (nonatomic, strong) NSString<Optional> *questionId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *questionType;
@property (nonatomic, strong) NSString<Optional> *questionData;
@property (nonatomic, strong) NSString<Optional> *answerNum;
@property (nonatomic, strong) NSString<Optional> *answerUserNum;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *groupId;
@property (nonatomic, strong) NSString<Optional> *questionStatus;
@property (nonatomic, strong) NSString<Optional> *bizId;
@property (nonatomic, strong) NSString<Optional> *questionTypeName;
@property (nonatomic, strong) QuestionRequestItem_voteInfo<Optional> *voteInfo;
@property (nonatomic, strong) QuestionRequestItem_userAnswer<Optional> *userAnswer;

@property (nonatomic, strong) NSMutableArray<Ignore> *myAnswers;
@property (nonatomic, strong) NSDictionary<Ignore> *answerDict;
- (BOOL)hasAnswer;
@end

@interface QuestionRequestItem_questionGroup : JSONModel
@property (nonatomic, strong) NSString<Optional> *groupId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *questionNum;
@property (nonatomic, strong) NSString<Optional> *groupType;
@property (nonatomic, strong) NSString<Optional> *groupStatus;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *answerNum;
@property (nonatomic, strong) NSString<Optional> *answerUserNum;
@property (nonatomic, strong) NSString<Optional> *bizId;
@property (nonatomic, strong) NSArray<Optional,QuestionRequestItem_question> *questions;

- (NSString *)answerString;
@end

@interface QuestionRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) NSString<Optional> *isAnswer;
@property (nonatomic, strong) QuestionRequestItem_questionGroup<Optional> *questionGroup;
@end

@interface QuestionRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) QuestionRequestItem_data<Optional> *data;
@end
