//
//  FSDataMappingTable.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FSDataMappingTable.h"

@implementation FSDataMappingTable
+ (InteractType)InteractTypeWithKey:(NSString *)key {
    NSDictionary *mappingDic = @{@"3":@(InteractType_Vote),
                                 @"4":@(InteractType_Comment),
                                 @"5":@(InteractType_Questionare),
                                 @"6":@(InteractType_SignIn),
                                 @"7":@(InteractType_Evaluate),
                                 @"8":@(InteractType_Homework)
                                 };
    NSNumber *number = [mappingDic valueForKey:key];
    if (number) {
        return number.integerValue;
    }
    return InteractType_Unknown;
}

+ (ResourceType)ResourceTypeWithKey:(NSString *)key {
    NSDictionary *mappingDic = @{@"word":@(ResourceType_Word),
                                 @"excel":@(ResourceType_Excel),
                                 @"ppt":@(ResourceType_PPT),
                                 @"pdf":@(ResourceType_PDF),
                                 @"text":@(ResourceType_TXT),
                                 @"video":@(ResourceType_Video),
                                 @"audio":@(ResourceType_Audio),
                                 @"image":@(ResourceType_Image)};
    NSNumber *number = [mappingDic valueForKey:key];
    if (number) {
        return number.integerValue;
    }
    return ResourceType_Unknown;
}

+ (QuestionType)QuestionTypeWithKey:(NSString *)key {
    NSDictionary *mappingDic = @{@"1":@(QuestionType_SingleChoose),
                                 @"2":@(QuestionType_MultiChoose),
                                 @"3":@(QuestionType_Fill)};
    NSNumber *number = [mappingDic valueForKey:key];
    if (number) {
        return number.integerValue;
    }
    return QuestionType_Unknown;
}

@end
