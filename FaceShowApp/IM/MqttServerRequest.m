//
//  MqttServerRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/4/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MqttServerRequest.h"
#import "IMManager.h"
#import "IMConfig.h"

@implementation MqttServerConfig
@end

@implementation MqttServerRequestItem_data
- (MqttServerConfig *)toServerConfig {
    NSArray<NSString *> *array = [self.mqttServer componentsSeparatedByString:@":"];
    MqttServerConfig *config = [[MqttServerConfig alloc]init];
    config.server = array.firstObject;
    config.port = array.lastObject.integerValue;
    return config;
}
@end

@implementation MqttServerRequestItem
@end

@interface MqttServerRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation MqttServerRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"policy.mqtt.server";
        self.bizSource = kBizSourse;
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
        self.type = @"tcp";
    }
    return self;
}
@end
