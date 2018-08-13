//
//  BasicDataRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol BasicDataRequestItem_data <NSObject> @end
@interface BasicDataRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *version;
@property (nonatomic, strong) NSString<Optional> *url;
@end

@interface BasicDataRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<BasicDataRequestItem_data,Optional> *data;
@end

@interface BasicDataRequest : YXGetRequest

@end
