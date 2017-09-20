//
//  QAFileUploadFirstStepRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAFileUploadFirstStepRequest.h"

@implementation QAFileUploadFirstStepRequestItem
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"aid"}];
}
@end
@implementation QAFileUploadFirstStepRequest
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"aid":@"id"}];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = @"http://newupload.yanxiu.com/fileUpload";
    }
    return self;
}
- (void)startRequestWithRetClass:(Class)retClass
                andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
    self.aid = @"app_wd_img";
    
    [self.request addData:self.file withFileName:self.name andContentType:nil forKey:@"file"];
    [super startRequestWithRetClass:retClass andCompleteBlock:completeBlock];
}
@end
