//
//  ScanPCLoginCodeRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/9/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface ScanPCLoginCodeRequest : YXGetRequest
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *bizType;
@end
