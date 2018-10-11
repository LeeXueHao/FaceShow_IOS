//
//  MineCertiRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol MineCertiRequest_Item_userCertList <NSObject> @end
@interface MineCertiRequest_Item_userCertList : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *realName;
@property (nonatomic, strong) NSString<Optional> *taskFinishedRate;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *signinRate;
@property (nonatomic, strong) NSString<Optional> *certName;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *certNo;
@property (nonatomic, strong) NSString<Optional> *certType;
@property (nonatomic, strong) NSString<Optional> *certificate;
@property (nonatomic, strong) NSString<Optional> *certPath;
@property (nonatomic, strong) NSString<Optional> *certState;
@property (nonatomic, strong) NSString<Optional> *certUrl;
@property (nonatomic, strong) NSString<Optional> *totalScore;
@property (nonatomic, strong) NSString<Optional> *hasRead;
@property (nonatomic, strong) NSString<Optional> *certExt;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@property (nonatomic, strong) NSString<Optional> *certId;
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) NSString<Optional> *mobilePhone;
@end

@protocol MineCertiRequest_Item_clazsCertList <NSObject> @end
@interface MineCertiRequest_Item_clazsCertList : JSONModel
@property (nonatomic, strong) NSString<Optional> *topicId;
@property (nonatomic, strong) NSString<Optional> *clazsType;
@property (nonatomic, strong) NSString<Optional> *listDescription;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSArray<MineCertiRequest_Item_userCertList,Optional> *userCertList;
@property (nonatomic, strong) NSString<Optional> *clazsStatus;
@property (nonatomic, strong) NSString<Optional> *clazsStatusName;
@property (nonatomic, strong) NSString<Optional> *manager;
@property (nonatomic, strong) NSString<Optional> *master;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *projectName;
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *clazsCertid;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@end

@interface MineCertiRequest_Item_data : JSONModel
@property (nonatomic, strong) NSArray<MineCertiRequest_Item_clazsCertList,Optional> *clazsCertList;
@end

@interface MineCertiRequest_Item : HttpBaseRequestItem
@property (nonatomic, strong) MineCertiRequest_Item_data<Optional> *data;
@end

@interface MineCertiRequest : YXGetRequest      
@property (nonatomic, strong) NSString<Optional> *paltId; // 平台id
@end


