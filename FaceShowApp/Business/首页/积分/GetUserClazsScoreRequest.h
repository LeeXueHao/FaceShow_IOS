//
//  GetUserClazsScoreRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol GetUserClazsScoreRequestItem_userScoreItem <NSObject>
@end
@interface GetUserClazsScoreRequestItem_userScoreItem : JSONModel
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *scoreType;
@property (nonatomic, strong) NSString<Optional> *scoreDefine;
@property (nonatomic, strong) NSString<Optional> *scoreName;
@property (nonatomic, strong) NSString<Optional> *scoreValue;
@end

@interface GetUserClazsScoreRequestItem_userScore : JSONModel
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

@interface GetUserClazsScoreRequestItem_data : JSONModel
@property (nonatomic, strong) GetUserClazsScoreRequestItem_userScore<Optional> *userScore;
@property (nonatomic, strong) NSString<Optional> *scoreRanking;
@end

@interface GetUserClazsScoreRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetUserClazsScoreRequestItem_data<Optional> *data;
@end

@interface GetUserClazsScoreRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString<Optional> *userId;//不填就是当前登录用户
@end
