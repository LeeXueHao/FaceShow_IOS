//
//  AddAppUseRecordRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface AddAppUseRecordRequest : YXGetRequest
@property (nonatomic, strong) NSString *platId;
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString *methord;
@end
