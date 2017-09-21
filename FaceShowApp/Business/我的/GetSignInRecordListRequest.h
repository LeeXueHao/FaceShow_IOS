//
//  GetSignInRecordListRequest.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetSignInRecordListRequestItem_UserSignIn : JSONModel
@property (nonatomic, strong) NSString<Optional> *userSignInId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *signinId;
@property (nonatomic, strong) NSString<Optional> *signinStatus;
@property (nonatomic, strong) NSString<Optional> *signinTime;
@property (nonatomic, strong) NSString<Optional> *signinRemark;
@property (nonatomic, strong) NSString<Optional> *signinDevice;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@end

@protocol GetSignInRecordListRequestItem_SignIn <NSObject>
@end
@interface GetSignInRecordListRequestItem_SignIn : JSONModel
@property (nonatomic, strong) NSString<Optional> *signInId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *antiCheat;
@property (nonatomic, strong) NSString<Optional> *successPrompt;
@property (nonatomic, strong) NSString<Optional> *openStatus;
@property (nonatomic, strong) NSString<Optional> *bizId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *totalUserNum;
@property (nonatomic, strong) NSString<Optional> *signInUserNum;
@property (nonatomic, strong) NSString<Optional> *opentStatusName;
@property (nonatomic, strong) NSString<Optional> *percent;
@property (nonatomic, strong) GetSignInRecordListRequestItem_UserSignIn<Optional> *userSignIn;
@end

@interface GetSignInRecordListRequestItem_Clazs : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@property (nonatomic, strong) NSString<Optional> *clazsStatus;
@property (nonatomic, strong) NSString<Optional> *clazsType;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *descriptionStr;
@property (nonatomic, strong) NSString<Optional> *isMaster;
@property (nonatomic, strong) NSString<Optional> *clazsStatusName;
@end

@protocol GetSignInRecordListRequestItem_Element <NSObject>
@end
@interface GetSignInRecordListRequestItem_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) GetSignInRecordListRequestItem_Clazs<Optional> *clazs;
@property (nonatomic, strong) NSArray<GetSignInRecordListRequestItem_SignIn,Optional> *signIns;
@end

@interface GetSignInRecordListRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<GetSignInRecordListRequestItem_Element, Optional> *elements;
@end

@interface GetSignInRecordListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetSignInRecordListRequestItem_Data<Optional> *data;
@end

@interface GetSignInRecordListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *orderBy; // 排序，如 createTime desc，status asc
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *offset;
@end
