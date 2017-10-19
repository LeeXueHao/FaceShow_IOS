//
//  GetSigninRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/10/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "GetSignInRecordListRequest.h"

@interface GetSigninRequestItem_data: JSONModel
@property (nonatomic, strong) GetSignInRecordListRequestItem_SignIn<Optional> *signIn;
@end

@interface GetSigninRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) GetSigninRequestItem_data<Optional> *data;
@end

@interface GetSigninRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@end

