//
//  LoginRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginRequest.h"

@interface LoginRequest ()
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *keepCookie;
@property (nonatomic, strong) NSString *backUrl;
@property (nonatomic, strong) NSString *crossCallback;
@end

@implementation LoginRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = @"http://orz.yanxiu.com/uc/newLogin";
        self.type = @"MOBILE";
        self.appKey = @"f749edf6-bc39-6ef9-8f81-158se5fds842";
        self.keepCookie = @"0";
//        self.backUrl = @"http%3A%2F%2Fmain.zgjiaoyan.com%2FYoungTeachers%2Findex.jsp";
        self.crossCallback = @"__jsonp_10006";
    }
    return self;
}

@end
