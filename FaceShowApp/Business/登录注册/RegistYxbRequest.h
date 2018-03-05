//
//  RegistYxbRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "SysUserItem.h"

@interface RegistYxbRequestItem_clazsInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@end

@interface RegistYxbRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *msg;
@property (nonatomic, strong) NSString<Optional> *hasRegistUser;// 0-未注册用户  1-用户中心已注册用户  2-研修宝已注册用户
@property (nonatomic, strong) SysUserItem<Optional> *sysUser;
@property (nonatomic, strong) RegistYxbRequestItem_clazsInfo<Optional> *clazsInfo;
@end

@interface RegistYxbRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) RegistYxbRequestItem_data<Optional> *data;
@end

@interface RegistYxbRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *mobile;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *code;
@end
