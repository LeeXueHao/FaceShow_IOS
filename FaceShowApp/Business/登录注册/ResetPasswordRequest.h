//
//  ResetPasswordRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface ResetPasswordRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *mobile;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSString<Optional> *password;
@end
