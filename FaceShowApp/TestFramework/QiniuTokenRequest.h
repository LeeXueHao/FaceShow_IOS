//
//  QiniuTokenRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface QiniuTokenRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *uid;
@property (nonatomic, strong) NSString<Optional> *uname;
@end

@interface QiniuTokenRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) QiniuTokenRequestItem_data<Optional> *data;
@end

@interface QiniuTokenRequest : YXGetRequest

@end
