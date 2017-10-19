//
//  UpdateUserInfoRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UpdateUserInfoRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *realName;
@property (nonatomic, strong) NSString<Optional> *sex;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *stage;
@property (nonatomic, strong) NSString<Optional> *schoolName;
@property (nonatomic, strong) NSString<Optional> *url;
@end
