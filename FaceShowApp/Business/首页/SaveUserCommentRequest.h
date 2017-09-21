//
//  SaveUserCommentRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface SaveUserCommentRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString *content;
@end
