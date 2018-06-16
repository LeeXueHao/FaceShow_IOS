//
//  FSDataMappingTable.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, InteractType) {
    InteractType_Vote,
    InteractType_Comment,
    InteractType_Questionare,
    InteractType_SignIn,
    InteractType_Evaluate,
    InteractType_Homework,
    InteractType_Unknown
};

typedef NS_ENUM(NSUInteger, ResourceType) {
    ResourceType_Word,
    ResourceType_Excel,
    ResourceType_PPT,
    ResourceType_PDF,
    ResourceType_TXT,
    ResourceType_Video,
    ResourceType_Audio,
    ResourceType_Image,
    ResourceType_Unknown
};

typedef NS_ENUM(NSUInteger, QuestionType) {
    QuestionType_SingleChoose,
    QuestionType_MultiChoose,
    QuestionType_Fill,
    QuestionType_Unknown
};

@interface FSDataMappingTable : NSObject
+ (InteractType)InteractTypeWithKey:(NSString *)key;
+ (ResourceType)ResourceTypeWithKey:(NSString *)key;
+ (QuestionType)QuestionTypeWithKey:(NSString *)key;
@end
