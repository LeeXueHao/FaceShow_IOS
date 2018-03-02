//
//  ClazsMemberListRequest.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "GetUserInfoRequest.h"

@protocol GetUserInfoRequestItem_Data<NSObject>
@end

@interface ClazsMemberListRequestItem_Data_Students : JSONModel
@property (nonatomic, strong) NSArray<GetUserInfoRequestItem_Data, Optional> *elements;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@end

@interface ClazsMemberListRequestItem_Data : JSONModel
@property (nonatomic, strong) NSArray<GetUserInfoRequestItem_Data, Optional> *masters;
@property (nonatomic, strong) ClazsMemberListRequestItem_Data_Students<Optional> *students;
@end

@interface ClazsMemberListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ClazsMemberListRequestItem_Data<Optional> *data;
@end

@interface ClazsMemberListRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *offset;
@end
