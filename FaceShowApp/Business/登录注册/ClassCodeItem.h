//
//  ClassCodeItem.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HttpBaseRequest.h"

@interface ClassCodeItem_clazsInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *clazsName;
@end

@interface ClassCodeItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) ClassCodeItem_clazsInfo<Optional> *clazsInfo;
@end

@interface ClassCodeItem : HttpBaseRequestItem
@property (nonatomic, strong) ClassCodeItem_data<Optional> *data;
@end
