//
//  SysUserItem.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/6.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SysUserItem : JSONModel
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *realName;
@property (nonatomic, strong) NSString<Optional> *mobilePhone;
@property (nonatomic, strong) NSString<Optional> *email;
@property (nonatomic, strong) NSString<Optional> *stage;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *userStatus;
@property (nonatomic, strong) NSString<Optional> *ucnterId;
@property (nonatomic, strong) NSString<Optional> *sex;
@property (nonatomic, strong) NSString<Optional> *school;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *stageName;
@property (nonatomic, strong) NSString<Optional> *subjectName;
@property (nonatomic, strong) NSString<Optional> *sexName;

- (UserModel *)toUserModel;
@end
