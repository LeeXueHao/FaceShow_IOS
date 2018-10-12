//
//  AddAppUseRecordRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

typedef NS_ENUM(NSUInteger, AppUseRecordActionType) {
    AppUseRecordActionType_AccountLogin = 1,
    AppUseRecordActionType_AutoLogin = 2,
    AppUseRecordActionType_GetStudentClazs = 3
};


@interface AddAppUseRecordRequest : YXGetRequest
@property (nonatomic, assign) AppUseRecordActionType actionType;
@end
