//
//  GetStudentClazsRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/18.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetStudentClazsRequest.h"

@implementation GetStudentClazsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [ConfigManager sharedInstance].server1_1;
        self.method = @"app.clazs.getStudentClazs";
    }
    return self;
}
@end
