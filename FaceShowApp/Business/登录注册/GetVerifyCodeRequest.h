//
//  GetVerifyCodeRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetVerifyCodeRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *mobile;
@end
