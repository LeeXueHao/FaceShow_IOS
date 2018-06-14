//
//  GetClazsSocresRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "GetUserClazsScoreRequest.h"

@protocol GetClazsSocresRequestItem_element <NSObject>
@end
@interface GetClazsSocresRequestItem_element : JSONModel
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
@property (nonatomic, strong) NSString<Optional> *totalScore;
@property (nonatomic, strong) NSArray<Optional,GetUserClazsScoreRequestItem_userScoreItem> *userScoreItems;
@end

@interface GetClazsSocresRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<Optional,GetClazsSocresRequestItem_element> *elements;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *pageNum;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSString<Optional> *lastPageNumber;
@end

@interface GetClazsSocresRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetClazsSocresRequestItem_data<Optional> *data;
@end

@interface GetClazsSocresRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *pageSize;

@end
