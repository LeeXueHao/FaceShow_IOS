//
//  SaveUserEvaluateRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface SaveUserEvaluateRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString *answers;
@end
