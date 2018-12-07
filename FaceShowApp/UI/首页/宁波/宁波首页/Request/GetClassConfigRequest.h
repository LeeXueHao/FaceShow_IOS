//
//  GetClassConfigRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetClassConfigRequest_Item_tabConf <NSObject> @end
@interface GetClassConfigRequest_Item_tabConf : JSONModel
@property (nonatomic, strong) NSString<Optional> *tabType;
@property (nonatomic, strong) NSString<Optional> *tabName;
@property (nonatomic, strong) NSString<Optional> *pageId;
@property (nonatomic, strong) NSString<Optional> *tabConfId;
@property (nonatomic, strong) NSString<Optional> *tabSort;
@end

@interface GetClassConfigRequest_Item_pageConf : JSONModel
@property (nonatomic, strong) NSString<Optional> *head;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *statisticsShow;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *pageSort;
@property (nonatomic, strong) NSString<Optional> *tabShow;
@property (nonatomic, strong) NSString<Optional> *headShow;//0:不显示 1:显示之前页面 2:只显示一张图的
@property (nonatomic, strong) NSString<Optional> *pageName;
@property (nonatomic, strong) NSString<Optional> *pageType;
@property (nonatomic, strong) NSString<Optional> *pageConfId;
@property (nonatomic, strong) NSString<Optional> *icon;
@end


@protocol GetClassConfigRequest_Item_pageList <NSObject> @end
@interface GetClassConfigRequest_Item_pageList : JSONModel
@property (nonatomic, strong) NSArray<GetClassConfigRequest_Item_tabConf,Optional> *tabConf;
@property (nonatomic, strong) GetClassConfigRequest_Item_pageConf<Optional> *pageConf;
@end

@protocol GetClassConfigRequest_Item_data <NSObject> @end
@interface GetClassConfigRequest_Item_data : JSONModel
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL resourceDown;
@property (nonatomic, strong) NSArray<GetClassConfigRequest_Item_pageList,Optional> *pageList;
@end

@interface GetClassConfigRequest_Item : HttpBaseRequestItem
@property (nonatomic, strong) GetClassConfigRequest_Item_data *data;
@end

@interface GetClassConfigRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *modleId;
@end

