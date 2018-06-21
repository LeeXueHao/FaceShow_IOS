//
//  PositionSignInRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "GetSignInRecordListRequest.h"

@interface PositionSignInRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<GetSignInRecordListRequestItem_SignIn,Optional> *signIns;
@end

@interface PositionSignInRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) PositionSignInRequestItem_data<Optional> *data;
@end

@interface PositionSignInRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@end
