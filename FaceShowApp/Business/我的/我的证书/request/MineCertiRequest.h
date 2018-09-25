//
//  MineCertiRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface MineCertiRequest_Item : JSONModel

@end

@interface MineCertiRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *orderBy; // 排序，如 createTime desc，status asc
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *offset;
@end


