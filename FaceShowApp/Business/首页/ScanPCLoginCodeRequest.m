//
//  ScanPCLoginCodeRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/9/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScanPCLoginCodeRequest.h"

@implementation ScanPCLoginCodeRequest
- (void)updateRequestUrlAndParams {
    NSString *userId = [UserManager sharedInstance].userModel.userID;
    NSString *token = [UserManager sharedInstance].userModel.token;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.crossJson];
    [param setValue:@([UserManager sharedInstance].userModel.projectClassInfo.data.projectInfo.projectId.integerValue) forKey:@"projectId"];
    [param setValue:@([UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId.integerValue) forKey:@"clazsId"];
    NSString *crossJson = [[param JsonString] stringByEscapingForURLArgument];
    NSString *paramStr = [NSString stringWithFormat:@"&userId=%@&userToken=%@&appKey=ze259mMel5pDFgYLgA3F2EssmUDTVGhn&crossJson=%@",userId,token,crossJson];
    NSString *completeUrl = [self.url stringByAppendingString:paramStr];
    [self request].url = [NSURL URLWithString:completeUrl];
    [self request].requestMethod = @"GET";
}
@end
