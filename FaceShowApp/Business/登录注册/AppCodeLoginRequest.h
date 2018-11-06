//
//  AppCodeLoginRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/6.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"


@interface AppCodeLoginRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *passport;
@end


@interface AppCodeLoginRequest : YXGetRequest
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *code;
@end
