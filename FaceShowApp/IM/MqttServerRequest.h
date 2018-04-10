//
//  MqttServerRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/4/10.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface MqttServerConfig: NSObject
@property (nonatomic, strong) NSString *server;
@property (nonatomic, assign) NSUInteger port;
@end

@interface MqttServerRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *mqttServer;

- (MqttServerConfig *)toServerConfig;
@end

@interface MqttServerRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) MqttServerRequestItem_data<Optional> *data;
@end

@interface MqttServerRequest : YXGetRequest
@property (nonatomic, strong) NSString *type; // tcp or ws, default is tcp
@end
