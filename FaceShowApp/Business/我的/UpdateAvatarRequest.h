//
//  UpdateAvatarRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UpdateAvatarRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *avatar;
@end
