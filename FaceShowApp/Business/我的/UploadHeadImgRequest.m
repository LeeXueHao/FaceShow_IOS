//
//  UploadHeadImgRequest.m
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UploadHeadImgRequest.h"
@implementation UploadHeadImgItem_TplData_Data

@end
@implementation UploadHeadImgItem_TplData

@end

@implementation UploadHeadImgItem

@end

@implementation UploadHeadImgRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"http://orz.yanxiu.com/easygo/multiUpload";
        self.urlHead = [NSString stringWithFormat:@"%@?token=%@", self.urlHead, self.token];
    }
    return self;
}
@end
