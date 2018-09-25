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
    NSDictionary *crossJson = @{
                                @"clazsId":[NSString stringWithFormat:@"%@",[UserManager sharedInstance].userModel.projectClassInfo.data.clazsInfo.clazsId],
                                @"bizType":self.bizType
                                };
    NSString *completeUrl = [self.url stringByAppendingString:[NSString stringWithFormat:@"&userId=%@&userToken=%@&appKey=ze259mMel5pDFgYLgA3F2EssmUDTVGhn&crossJson=%@",userId,token,[[crossJson JsonString]stringByEscapingForURLArgument]]];
    [self request].url = [NSURL URLWithString:completeUrl];
    [self request].requestMethod = @"GET";
}
@end
