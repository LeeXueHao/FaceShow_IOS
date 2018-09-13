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
    NSString *completeUrl = [self.url stringByAppendingString:[NSString stringWithFormat:@"&userId=%@&userToken=%@&appKey=ze259mMel5pDFgYLgA3F2EssmUDTVGhn",[UserManager sharedInstance].userModel.userID,[UserManager sharedInstance].userModel.token]];
    [self request].url = [NSURL URLWithString:completeUrl];
    [self request].requestMethod = @"GET";
}
@end
