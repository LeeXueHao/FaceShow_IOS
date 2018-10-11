//
//  MineCertiReadRequest.h
//  FaceShowApp
//
//  Created by SRT on 2018/10/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface MineCertiReadRequest_Item:HttpBaseRequestItem
@end

@interface MineCertiReadRequest : YXGetRequest
@property (nonatomic, strong) NSString *certId;
@end
