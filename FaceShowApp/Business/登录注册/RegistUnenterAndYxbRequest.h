//
//  RegistUnenterAndYxbRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/6.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "SysUserItem.h"

@interface RegistUnenterAndYxbRequestItem_data : JSONModel
@property (nonatomic, strong) SysUserItem<Optional> *sysUser;
@end

@interface RegistUnenterAndYxbRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) RegistUnenterAndYxbRequestItem_data<Optional> *data;
@end

@interface RegistUnenterAndYxbRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *mobile;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *password;
@end
