//
//  GetUserNoReadCertRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/10/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetUserNoReadCertRequest_Item_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *existNoReadCert;
@end

@interface GetUserNoReadCertRequest_Item : HttpBaseRequestItem
@property (nonatomic, strong) GetUserNoReadCertRequest_Item_data<Optional> *data;
@end

@interface GetUserNoReadCertRequest : YXGetRequest
@end
