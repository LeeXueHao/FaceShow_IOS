//
//  GetResourceListRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetResourceListRequestItem_resList <NSObject> @end
@interface GetResourceListRequestItem_resList : JSONModel
@property (nonatomic, strong) NSString<Optional> *publisherName;
@property (nonatomic, strong) NSString<Optional> *suffix;
@property (nonatomic, strong) NSString<Optional> *clazzId;
@property (nonatomic, strong) NSString<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *resNum;
@property (nonatomic, strong) NSString<Optional> *reslistId;
@property (nonatomic, strong) NSString<Optional> *viewNum;
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *createTimeStr;
@property (nonatomic, strong) NSString<Optional> *ai;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *downNum;
@property (nonatomic, strong) NSString<Optional> *tagId;
@property (nonatomic, strong) NSString<Optional> *viewNumSum;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *downNumSum;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *totalClazsStudentNum;
@property (nonatomic, strong) NSString<Optional> *viewClazsStudentNum;
@property (nonatomic, strong) NSString<Optional> *publisherId;
@property (nonatomic, strong) NSString<Optional> *resourceKey;
@end

@protocol GetResourceListRequestItem_tagList <NSObject> @end
@interface GetResourceListRequestItem_tagList : JSONModel
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *updateTime;
@property (nonatomic, strong) NSString<Optional> *taglistId;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *resNum;
@end

@interface GetResourceListRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<GetResourceListRequestItem_resList,Optional> *resList;
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSArray<GetResourceListRequestItem_tagList,Optional> *tagList;
@end

@interface GetResourceListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetResourceListRequestItem_data<Optional> *data;
@end

NS_ASSUME_NONNULL_BEGIN

@interface GetResourceListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *tagId;
@end

NS_ASSUME_NONNULL_END
