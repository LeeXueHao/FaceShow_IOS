//
//  GetToolsRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetToolsRequestItem_eventObj : JSONModel
@property (nonatomic, strong) NSString<Optional> *eventType;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *vHtml;
@end

@protocol GetToolsRequestItem_tool
@end
@interface GetToolsRequestItem_tool : JSONModel
@property (nonatomic, strong) NSString<Optional> *toolType;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) GetToolsRequestItem_eventObj<Optional> *eventObj;
@property (nonatomic, strong) NSArray<GetToolsRequestItem_tool,Optional> *subTools;
@end

@interface GetToolsRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<GetToolsRequestItem_tool,Optional> *tools;
@property (nonatomic, strong) NSArray<GetToolsRequestItem_tool,Optional> *notices;
@end

@interface GetToolsRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetToolsRequestItem_data<Optional> *data;
@end

// http://wiki.yanxiu.com/pages/viewpage.action?pageId=12327123
@interface GetToolsRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *platId;
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end
