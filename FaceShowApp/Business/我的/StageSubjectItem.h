//
//  StageSubjectItem.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol StageSubjectItem_Subject <NSObject>
@end
@interface StageSubjectItem_Subject : JSONModel
@property (nonatomic, strong) NSString *subjectID;
@property (nonatomic, strong) NSString *name;
@end

@protocol StageSubjectItem_Stage <NSObject>
@end
@interface StageSubjectItem_Stage : JSONModel
@property (nonatomic, strong) NSString *stageID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<StageSubjectItem_Subject, Optional> *subjects;
@end

@interface StageSubjectItem : JSONModel
@property (nonatomic, strong) NSArray<StageSubjectItem_Stage, Optional> *data;
@end
