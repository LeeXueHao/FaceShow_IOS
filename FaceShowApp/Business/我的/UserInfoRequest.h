//
//  UserInfoRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface UserInfoRequestItem_Data : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *realName;
@property (nonatomic, copy) NSString<Optional> *mobilePhone;
@property (nonatomic, copy) NSString<Optional> *email;
@property (nonatomic, copy) NSString<Optional> *stage;

@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, copy) NSString<Optional> *userStatus;
@property (nonatomic, copy) NSString<Optional> *ucnterId;
@property (nonatomic, copy) NSString<Optional> *sex;
@property (nonatomic, copy) NSString<Optional> *school;
@property (nonatomic, copy) NSString<Optional> *avatar;

@end

@interface UserInfoRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) UserInfoRequestItem_Data *data;
@end

@interface UserInfoRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *userId;
@end
