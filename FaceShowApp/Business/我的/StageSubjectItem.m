//
//  StageSubjectItem.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StageSubjectItem.h"

@implementation StageSubjectItem_Subject
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"subjectID"}];
}
@end

@implementation StageSubjectItem_Stage
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"stageID",@"sub":@"subjects"}];
}
@end

@implementation StageSubjectItem
@end
