//
//  QuestionnaireViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "FSDataMappingTable.h"

@interface QuestionnaireViewController : BaseViewController
- (instancetype)initWithStepId:(NSString *)stepId interactType:(InteractType)type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) void(^completeBlock) ();
@end
