//
//  UserSignInRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UserSignInRequestItem_Data : JSONModel
@property (nonatomic, strong) NSString<Optional> *userSignInId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *signinId;
@property (nonatomic, strong) NSString<Optional> *signinStatus;
@property (nonatomic, strong) NSString<Optional> *signinTime;
@property (nonatomic, strong) NSString<Optional> *signinRemark;
@property (nonatomic, strong) NSString<Optional> *signinDevice;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *successPrompt;
@end

@interface UserSignInRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) UserSignInRequestItem_Data<Optional> *data;
@end

@interface UserSignInRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@end
