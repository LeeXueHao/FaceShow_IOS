//
//  ScanClazsCodeRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScanClazsCodeRequest.h"

@implementation ScanClazsCodeRequest
- (void)updateRequestUrlAndParams {
    NSString *completeUrl = self.url;
    if ([UserManager sharedInstance].loginStatus) {
        completeUrl = [NSString stringWithFormat:@"%@&token=%@",completeUrl,[UserManager sharedInstance].userModel.token];
    }
    [self request].url = [NSURL URLWithString:completeUrl];
    [self request].requestMethod = @"GET";
}
@end
