//
//  ReportRequest.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetRequest.h"

@interface ReportRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) NSString<Optional> *desc;
@end

@interface ReportRequest : GetRequest
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString<Optional> *desc;
@end
