//
//  UploadHeadImgRequest.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
@protocol UploadHeadImgItem_TplData_Data
@end
@interface UploadHeadImgItem_TplData_Data : JSONModel
@property (nonatomic, copy) NSString<Optional> *uniqueKey;
@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *shortUrl;
@property (nonatomic, copy) NSString<Optional> *originalUrl;
@end

@interface UploadHeadImgItem_TplData : JSONModel
@property (nonatomic, strong) NSArray<UploadHeadImgItem_TplData_Data,Optional> *data;
@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *message;
@end


@interface UploadHeadImgItem : HttpBaseRequestItem
@property (nonatomic, strong) UploadHeadImgItem_TplData<Optional> *tplData;
@end
@interface UploadHeadImgRequest : YXPostRequest

@end
