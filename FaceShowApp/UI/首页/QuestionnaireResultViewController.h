//
//  QuestionnaireResultViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface QuestionnaireResultViewController : BaseViewController
- (instancetype)initWithStepId:(NSString *)stepId;
@property (nonatomic, strong) NSString *name;
@end
