//
//  GetUserInfoRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetUserInfoRequestItem_Data : JSONModel
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
@property (nonatomic, copy) NSString<Optional> *stageName;
@property (nonatomic, copy) NSString<Optional> *subjectName;
@property (nonatomic, copy) NSString<Optional> *sexName;

@end

@interface GetUserInfoRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetUserInfoRequestItem_Data<Optional> *data;
@end

@interface GetUserInfoRequest : YXGetRequest
@end
